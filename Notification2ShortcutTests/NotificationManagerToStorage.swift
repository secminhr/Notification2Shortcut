//
//  NotificationManagerToStorage.swift
//  Notification2ShortcutTests
//
//  Created by secminhr on 2025/6/13.
//

import Testing
import UserNotifications
@testable import Notification2Shortcut

fileprivate class InMemoryStorage: NotificationStorage {
    var notifications: [N2SNotification] = []
    
    func add(_ notification: N2SNotification) {
        notifications.append(notification)
    }
}

fileprivate struct DumbSendingSender: NotificationSender {
    func sendNotification(id: String, notification: Notification2Shortcut.N2SNotification, trigger: UNNotificationTrigger) {
        // do nothing
    }
}

struct NotificationManagerToStorage {

    @Test func createNotifictionWithTitle() async throws {
        let notification = N2SNotification("Title")
        let storage = InMemoryStorage()
        var notificationManager = NotificationManager(storage: storage, sender: DumbSendingSender())
        notificationManager.add(notification, id: "id")
        
        try #require(storage.notifications.count == 1)
        #expect(storage.notifications[0] == notification)
    }
}
