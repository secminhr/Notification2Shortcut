//
//  NotificationEditorViewModel.swift
//  Notification2Shortcut
//
//  Created by secminhr on 2025/6/19.
//

import Foundation
import Combine

class NotificationEditorViewModel: ObservableObject {
    private let manager: NotificationManager
    
    private let notificationId: String
    @Published var title: String
    @Published var subtitle: String
    @Published var body: String
    @Published var sendingId: String
    @Published private(set) var saveError: Bool = false
    
    init(_ manager: NotificationManager,
         editing notification: N2SNotification,
         retrySave: Int = 3
    ) {
        self.manager = manager
        self.notificationId = notification.id
        self.title = notification.title
        self.subtitle = notification.subtitle ?? ""
        self.body = notification.body ?? ""
        self.sendingId = notification.notificationSendingId
        
        $title.combineLatest($subtitle, $body, $sendingId)
            .dropFirst() // drop init value
            .asyncTryMap(retry: retrySave) { (title, subtitle, body, sendingId) in
                var notification = N2SNotification(title, id: self.notificationId)
                notification.subtitle = subtitle
                notification.body = body
                notification.notificationSendingId = sendingId
                try await manager.update(notification)
                return false
            }
            .replaceError(with: true)
            .receive(on: RunLoop.main)
            .assign(to: &$saveError)
    }
}

extension Publisher {
    func asyncTryMap<T>(retry: Int, _ transform: @escaping (Output) async throws -> T) -> Publishers.FlatMap<Publishers.Retry<Deferred<Future<T, Error>>>,
                            Publishers.SetFailureType<Self, Error>> {
        self.flatMap { output in
            Deferred {
                Future<T, Error> { promise in
                    Task {
                        do {
                            let result = try await transform(output)
                            promise(.success(result))
                        } catch {
                            promise(.failure(error))
                        }
                    }
                }
            }.retry(retry)
        }
    }
}
