//
//  NotificationManager.swift
//  Notification2Shortcut
//
//  Created by secminhr on 2025/6/13.
//

import UserNotifications

struct NotificationManager {
    private var storage: NotificationStorage
    private let sender: NotificationSender
    
    private var notifications: [String: N2SNotification] = [:]
    init(storage: NotificationStorage, sender: NotificationSender) {
        self.storage = storage
        self.sender = sender
    }
    
    mutating func add(_ notification: N2SNotification, id: String) {
        storage.add(notification)
        notifications[id] = notification
    }
    
    func sendNotification(id: String, withTrigger trigger: UNNotificationTrigger) {
        sender.sendNotification(id: id, notification: notifications[id]!, trigger: trigger)
    }
}
