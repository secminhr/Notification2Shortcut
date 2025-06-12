//
//  Notification2ShortcutTests.swift
//  Notification2ShortcutTests
//
//  Created by secminhr on 2025/6/12.
//

import Testing
@testable import Notification2Shortcut

class InMemoryStorage: NotificationStorage {
    var notifications: [Notification] = []
    
    func add(_ notification: Notification) {
        notifications.append(notification)
    }
}

struct Notification2ShortcutTests {
    @Test func createNotifictionWithTitle() async throws {
        let notification = Notification("Title")
        let storage = InMemoryStorage()
        var notificationManager = NotificationManager(storage: storage)
        notificationManager.add(notification)
        
        try #require(storage.notifications.count == 1)
        #expect(storage.notifications[0] == notification)
    }

}
