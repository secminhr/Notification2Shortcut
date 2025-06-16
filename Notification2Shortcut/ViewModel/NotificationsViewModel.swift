//
//  NotificationsViewModel.swift
//  Notification2Shortcut
//
//  Created by secminhr on 2025/6/14.
//

import Foundation
import OrderedCollections
import SwiftUI

@Observable
class NotificationsViewModel {
    // we use a stored property rather than computed property via notificationManager.notificationIds
    // since NotificationManager is not observable
    private(set) var notifications: [N2SNotification]
    var selectedId: String? = nil
    
    var selectedNotification: N2SNotification? {
        guard let id = selectedId else { return nil }
        
        return notificationManager.getNotification(id: id)
    }
    
    private let notificationManager: NotificationManager
    init(notificationManager: NotificationManager) {
        self.notificationManager = notificationManager
        notifications = notificationManager.notifications
    }
    
    func newNotification() async throws {
        let notification = N2SNotification(notificationSendingId: "notify", id: UUID().uuidString)
        try await notificationManager.update(notification)
        
        notifications = notificationManager.notifications
        selectedId = notification.id
    }
}

