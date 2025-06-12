//
//  Notification2ShortcutTests.swift
//  Notification2ShortcutTests
//
//  Created by secminhr on 2025/6/12.
//

import Testing
@testable import Notification2Shortcut
import UserNotifications

class InMemoryStorage: NotificationStorage {
    var notifications: [N2SNotification] = []
    
    func add(_ notification: N2SNotification) {
        notifications.append(notification)
    }
}

class SuccessSender: NotificationSender {
    var sentNotifications: [String: (N2SNotification, UNNotificationTrigger)] = [:]
    
    func sendNotification(id: String, notification: Notification2Shortcut.N2SNotification, trigger: UNNotificationTrigger) {
        sentNotifications[id] = (notification, trigger)
    }
}

struct Notification2ShortcutTests {
    @Test func createNotifictionWithTitle() async throws {
        let notification = N2SNotification("Title")
        let storage = InMemoryStorage()
        var notificationManager = NotificationManager(storage: storage, sender: SuccessSender())
        notificationManager.add(notification, id: "id")
        
        try #require(storage.notifications.count == 1)
        #expect(storage.notifications[0] == notification)
    }
    
    @Test func sendNotification() async throws {
        let notification = N2SNotification("Title")
        let storage = InMemoryStorage()
        
        let sender = SuccessSender()
        var notificationManager = NotificationManager(storage: storage, sender: sender)
        notificationManager.add(notification, id: "id")
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
        notificationManager.sendNotification(id: "id", withTrigger: trigger)
        
        try #require(sender.sentNotifications.contains {
            $0.key == "id"
        })
        #expect(sender.sentNotifications["id"]! == (notification, trigger))
    }
}
