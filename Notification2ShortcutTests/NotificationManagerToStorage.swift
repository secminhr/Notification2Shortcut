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
    let initNotifications: [String : Notification2Shortcut.N2SNotification]
    var notifications: [String: N2SNotification]
    
    init(_ notificatios: [String: N2SNotification] = [:]) {
        self.initNotifications = notificatios
        self.notifications = notificatios
    }
    
    func update(_ notification: N2SNotification, id: String) async {
        notifications[id] = notification
    }
}

struct FailingStorage: NotificationStorage {
    enum Condition {
        case initialize, update
    }
    enum StorageError: Error {
        case err
    }
    
    private let failAt: [Condition]
    init(failAt: [Condition]) {
        self.failAt = failAt
    }
    
    var initNotifications: [String : Notification2Shortcut.N2SNotification] {
        get async throws {
            if failAt.contains(.initialize) {
                throw StorageError.err
            } else {
                [:]
            }
        }
    }
    
    func update(_ notification: Notification2Shortcut.N2SNotification, id: String) async throws {
        if failAt.contains(.update) {
            throw StorageError.err
        }
    }
}

struct DumbSender: NotificationSender {
    func sendNotification(notification: N2SNotification, trigger: UNNotificationTrigger) {
        // do nothing
    }
}

struct NotificationManagerToStorage {
    let emptyStorage = InMemoryStorage()
    
    @Test func createNotifictionWithTitle() async throws {
        let notification = N2SNotification("Title")
        let manager = try await NotificationManager(storage: emptyStorage, sender: DumbSender())
        try await manager.update(notification, id: "id")
        
        try #require(emptyStorage.notifications.count == 1)
        #expect(emptyStorage.notifications["id"] == notification)
    }
    
    @Test func updateNotification() async throws {
        var notification = N2SNotification("Title")
        let manager = try await NotificationManager(storage: emptyStorage, sender: DumbSender())
        try await manager.update(notification, id: "id")
        
        notification.title = "Updated Title"
        notification.body = "Updated Body"
        
        try await manager.update(notification, id: "id")
        
        try #require(emptyStorage.notifications.count == 1)
        #expect(emptyStorage.notifications["id"] == notification)
    }
    
    @Test func multipleNotifications() async throws {
        let notification1 = N2SNotification("T1")
        let notification2 = N2SNotification("T2")
        
        let manager = try await NotificationManager(storage: emptyStorage, sender: DumbSender())
        try await manager.update(notification1, id: "1")
        try await manager.update(notification2, id: "2")
        
        try #require(emptyStorage.notifications.count == 2)
        #expect(emptyStorage.notifications["1"] == notification1)
        #expect(emptyStorage.notifications["2"] == notification2)
    }
    
    @Test func restoreFromStorage() async throws {
        let notifications = [
            "N1": N2SNotification("T1"),
            "N2": N2SNotification("T2")
        ]
        let predefinedStorage = InMemoryStorage(notifications)
        let manager = try await NotificationManager(storage: predefinedStorage, sender: DumbSender())
        
        #expect(manager.getNotification(id: "N1") == notifications["N1"])
        #expect(manager.getNotification(id: "N2") == notifications["N2"])
        #expect(manager.getNotification(id: "None") == nil)
    }
    
    @Test func storageObtainingInitialNotificationFail() async throws {
        var errorCaught = false
        do {
            let _ = try await NotificationManager(storage: FailingStorage(failAt: [.initialize]), sender: DumbSender())
        } catch NotificationManager.Error.initFail(storageError: let storageError) {
            errorCaught = true
            #expect(storageError as! FailingStorage.StorageError == FailingStorage.StorageError.err)
        }
        #expect(errorCaught)
    }
    
    @Test func storageUpdateFail() async throws {
        let manager = try await NotificationManager(storage: FailingStorage(failAt: [.update]), sender: DumbSender())
        
        var errorCaught = false
        do {
            try await manager.update(N2SNotification(), id: "id")
        } catch NotificationManager.Error.updateFail(storageError: let storageError) {
            errorCaught = true
            #expect(storageError as! FailingStorage.StorageError == FailingStorage.StorageError.err)
        }
        #expect(errorCaught)
        #expect(manager.getNotification(id: "id") == nil)
    }
}
