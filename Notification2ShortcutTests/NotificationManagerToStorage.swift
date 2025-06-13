//
//  NotificationManagerToStorage.swift
//  Notification2ShortcutTests
//
//  Created by secminhr on 2025/6/13.
//

import Testing
import UserNotifications
@testable import Notification2Shortcut

class InMemoryStorage: NotificationStorage {
    private var notificationDict: [String: N2SNotification] = [:]
    private var notificationIds: [String] = []
    var notifications: [N2SNotification] {
        return notificationIds.map { notificationDict[$0]! }
    }
    
    func update(_ notification: N2SNotification, id: String) {
        notificationDict[id] = notification
        if !notificationIds.contains(id) {
            notificationIds.append(id)
        }
    }
}

struct DumbSender: NotificationSender {
    func sendNotification(id: String, notification: Notification2Shortcut.N2SNotification, trigger: UNNotificationTrigger) {
        // do nothing
    }
}

struct NotificationManagerToStorage {
    let storage = InMemoryStorage()
    
    @Test func createNotifictionWithTitle() async throws {
        let notification = N2SNotification("Title")
        var notificationManager = NotificationManager(storage: storage, sender: DumbSender())
        notificationManager.update(notification, id: "id")
        
        try #require(storage.notifications.count == 1)
        #expect(storage.notifications[0] == notification)
    }
    
    @Test func updateNotification() async throws {
        var notification = N2SNotification("Title")
        var notificationManager = NotificationManager(storage: storage, sender: DumbSender())
        notificationManager.update(notification, id: "id")
        
        notification.title = "Updated Title"
        notification.body = "Updated Body"
        
        notificationManager.update(notification, id: "id")
        
        try #require(storage.notifications.count == 1)
        #expect(storage.notifications[0] == notification)
    }
}

