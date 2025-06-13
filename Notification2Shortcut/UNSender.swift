//
//  UNSender.swift
//  Notification2Shortcut
//
//  Created by secminhr on 2025/6/13.
//

import Foundation
@preconcurrency import UserNotifications

class UNSender: NotificationSender {
    func sendNotification(notification: N2SNotification, trigger: UNNotificationTrigger) async throws {
        let center = UNUserNotificationCenter.current()
        let authorized = try await center.requestAuthorization(options: [.badge, .alert, .sound])
        
        if authorized {
            let content = getNotificationContent(notification: notification)
            let request = UNNotificationRequest(identifier: notification.notificationSendingId, content: content, trigger: trigger)
            
            // the request need to be sent from here (main actor) to non-isolated function center.add
            // we use @preconcurrency import UserNotifications to suppress the error since UNNotificationRequest is not Sendable
            try await center.add(request)
        }
    }
    
    private func getNotificationContent(notification: N2SNotification) -> UNNotificationContent {
        let content = UNMutableNotificationContent()
        
        content.title = notification.title
        if let subtitle = notification.subtitle {
            content.subtitle = subtitle
        }
        if let body = notification.body {
            content.body = body
        }
        
        return content
    }
}
