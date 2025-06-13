//
//  NotificationManagerToSender.swift
//  Notification2ShortcutTests
//
//  Created by secminhr on 2025/6/12.
//

import Testing
@testable import Notification2Shortcut
import UserNotifications

fileprivate struct DumbStorage: NotificationStorage {
    var notifications: [Notification2Shortcut.N2SNotification] = []
    
    mutating func update(_ notification: Notification2Shortcut.N2SNotification, id: String) {
        // do nothing
    }
}

fileprivate class SuccessSender: NotificationSender {
    var sentNotifications: [String: (N2SNotification, UNNotificationTrigger)] = [:]
    
    func sendNotification(id: String, notification: Notification2Shortcut.N2SNotification, trigger: UNNotificationTrigger) {
        sentNotifications[id] = (notification, trigger)
    }
}

struct NotificationManagerToSender {
    @Test func sendNotification() async throws {
        let notification = N2SNotification("Title")
        
        let sender = SuccessSender()
        var notificationManager = NotificationManager(storage: DumbStorage(), sender: sender)
        notificationManager.update(notification, id: "id")
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
        notificationManager.sendNotification(id: "id", withTrigger: trigger)
        
        try #require(sender.sentNotifications.contains {
            $0.key == "id"
        })
        #expect(sender.sentNotifications["id"]! == (notification, trigger))
    }
}
