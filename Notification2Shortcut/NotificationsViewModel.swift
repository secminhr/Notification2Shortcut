//
//  NotificationsViewModel.swift
//  Notification2Shortcut
//
//  Created by secminhr on 2025/6/14.
//

import Foundation

struct NotificationsViewModel {
    // we use a stored property rather than computed property via notificationManager.notificationIds
    // since NotificationManager is not observable
    private(set) var notificationIds: [String]
    var selectedIndex: Int? = nil
    
    var selectedNotification: N2SNotification? {
        guard let index = selectedIndex else { return nil }
        guard index < notificationIds.count else { return nil }
        
        let id = notificationIds[index]
        return notificationManager.getNotification(id: id)
    }
    
    private let notificationManager: NotificationManager
    init(notificationManager: NotificationManager) {
        self.notificationManager = notificationManager
        notificationIds = notificationManager.notificationIds
    }
    
    mutating func newNotification() async throws {
        let notification = N2SNotification(notificationSendingId: "notify")
        let id = UUID().uuidString
        try await notificationManager.update(notification, id: id)
        notificationIds.append(id)
    }
}

