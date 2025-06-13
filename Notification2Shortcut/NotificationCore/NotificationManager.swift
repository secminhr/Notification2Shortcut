//
//  NotificationManager.swift
//  Notification2Shortcut
//
//  Created by secminhr on 2025/6/13.
//

import UserNotifications

class NotificationManager {
    private var storage: NotificationStorage
    private let sender: NotificationSender
    
    private var notifications: [String: N2SNotification]
    init(storage: NotificationStorage, sender: NotificationSender) async throws {
        self.storage = storage
        self.sender = sender
        do {
            self.notifications = try await storage.initNotifications
        } catch {
            throw Error.initFail
        }
    }
    
    func update(_ notification: N2SNotification, id: String) async throws {
        do {
            try await storage.update(notification, id: id)
            notifications[id] = notification
        } catch {
            throw Error.updateFail
        }
    }
    
    func getNotification(id: String) -> N2SNotification? {
        return notifications[id]
    }
    
    func sendNotification(id: String, withTrigger trigger: UNNotificationTrigger) async {
        await sender.sendNotification(id: id, notification: notifications[id]!, trigger: trigger)
    }
}

extension NotificationManager {
    nonisolated enum Error: Swift.Error {
        case initFail, updateFail
    }
}
