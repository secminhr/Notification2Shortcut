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
    var selectedId: String? = nil
    
    var selectedNotification: N2SNotification? {
        guard let id = selectedId else { return nil }
        
        return notificationManager.getNotification(id: id)
    }
    
    let notificationManager: NotificationManager
    init(notificationManager: NotificationManager) {
        self.notificationManager = notificationManager
    }
    
    func newNotification() async throws {
        let notification = N2SNotification(notificationSendingId: "notify", id: UUID().uuidString)
        try await notificationManager.update(notification)
        
        selectedId = notification.id
    }
}

