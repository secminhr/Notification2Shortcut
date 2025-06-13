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
    init(storage: NotificationStorage, sender: NotificationSender) async {
        self.storage = storage
        self.sender = sender
        self.notifications = await storage.initNotifications
    }
    
    func update(_ notification: N2SNotification, id: String) async {
        notifications[id] = notification
        await storage.update(notification, id: id)
    }
    
    func getNotification(id: String) -> N2SNotification? {
        return notifications[id]
    }
    
    func sendNotification(id: String, withTrigger trigger: UNNotificationTrigger) async {
        await sender.sendNotification(id: id, notification: notifications[id]!, trigger: trigger)
    }
}
