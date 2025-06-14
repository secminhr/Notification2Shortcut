//
//  NotificationManagerToStorage.swift
//  Notification2ShortcutTests
//
//  Created by secminhr on 2025/6/13.
//

import Testing
import UserNotifications
import OrderedCollections
@testable import Notification2Shortcut


class InMemoryStorage: NotificationStorage {
    let initNotifications: [N2SNotification]
    var notifications: [String: N2SNotification]
    
    init(_ notifications: [N2SNotification] = []) {
        self.initNotifications = notifications
        self.notifications = [:]
        for notification in notifications {
            self.notifications[notification.id] = notification
        }
    }
    
    func update(_ notification: N2SNotification) async {
        notifications[notification.id] = notification
    }
}

extension OrderedDictionary {
    func toDictionary() -> [Key: Value] {
        var result: [Key: Value] = [:]
        for (k, v) in self {
            result[k] = v
        }
        return result
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
    
    var initNotifications: [N2SNotification] {
        get async throws {
            if failAt.contains(.initialize) {
                throw StorageError.err
            } else {
                []
            }
        }
    }
    
    func update(_ notification: N2SNotification) async throws {
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
        let notification = N2SNotification("Title", id: "id")
        let manager = try await NotificationManager(storage: emptyStorage, sender: DumbSender())
        try await manager.update(notification)
        
        try #require(emptyStorage.notifications.count == 1)
        #expect(emptyStorage.notifications["id"] == notification)
    }
    
    @Test func updateNotification() async throws {
        var notification = N2SNotification("Title", id: "id")
        let manager = try await NotificationManager(storage: emptyStorage, sender: DumbSender())
        try await manager.update(notification)
        
        notification.title = "Updated Title"
        notification.body = "Updated Body"
        
        try await manager.update(notification)
        
        try #require(emptyStorage.notifications.count == 1)
        #expect(emptyStorage.notifications["id"] == notification)
    }
    
    @Test func multipleNotifications() async throws {
        let notification1 = N2SNotification("T1", id: "1")
        let notification2 = N2SNotification("T2", id: "2")
        
        let manager = try await NotificationManager(storage: emptyStorage, sender: DumbSender())
        try await manager.update(notification1)
        try await manager.update(notification2)
        
        try #require(emptyStorage.notifications.count == 2)
        #expect(emptyStorage.notifications["1"] == notification1)
        #expect(emptyStorage.notifications["2"] == notification2)
    }
    
    @Test func restoreFromStorage() async throws {
        let notifications: [N2SNotification] = [
            N2SNotification("T1", id: "N1"),
            N2SNotification("T2", id: "N2")
        ]
        let predefinedStorage = InMemoryStorage(notifications)
        let manager = try await NotificationManager(storage: predefinedStorage, sender: DumbSender())
        
        #expect(manager.getNotification(id: "N1") == notifications[0])
        #expect(manager.getNotification(id: "N2") == notifications[1])
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
            try await manager.update(N2SNotification(id: "id"))
        } catch NotificationManager.Error.updateFail(storageError: let storageError) {
            errorCaught = true
            #expect(storageError as! FailingStorage.StorageError == FailingStorage.StorageError.err)
        }
        #expect(errorCaught)
        #expect(manager.getNotification(id: "id") == nil)
    }
}
