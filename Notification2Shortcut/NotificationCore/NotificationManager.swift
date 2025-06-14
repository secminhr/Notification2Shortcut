//
//  NotificationManager.swift
//  Notification2Shortcut
//
//  Created by secminhr on 2025/6/13.
//

import UserNotifications
import OrderedCollections

class NotificationManager {
    private var storage: NotificationStorage
    private let sender: NotificationSender
    
    private var notifications: OrderedDictionary<String, N2SNotification>
    public var notificationIds: OrderedSet<String> { notifications.keys }
    
    init(storage: NotificationStorage, sender: NotificationSender) async throws {
        self.storage = storage
        self.sender = sender
        do {
            self.notifications = try await storage.initNotifications
        } catch {
            throw Error.initFail(storageError: error)
        }
    }
    
    func update(_ notification: N2SNotification, id: String) async throws {
        do {
            try await storage.update(notification, id: id)
            notifications[id] = notification
        } catch {
            throw Error.updateFail(storageError: error)
        }
    }
    
    func getNotification(id: String) -> N2SNotification? {
        return notifications[id]
    }
    
    func sendNotification(id: String, withTrigger trigger: UNNotificationTrigger) async throws {
        guard let notification = getNotification(id: id) else {
            throw Error.notificationNotExists
        }
        
        do {
            try await sender.sendNotification(notification: notification, trigger: trigger)
        } catch {
            throw Error.sendNotificationFail(senderError: error)
        }
    }
}

extension NotificationManager {
    nonisolated enum Error: Swift.Error {
        case initFail(storageError: Swift.Error)
        case updateFail(storageError: Swift.Error)
        case notificationNotExists
        case sendNotificationFail(senderError: Swift.Error)
    }
}
