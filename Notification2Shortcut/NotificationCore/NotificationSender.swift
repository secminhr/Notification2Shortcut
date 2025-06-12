//
//  NotificationSender.swift
//  Notification2Shortcut
//
//  Created by secminhr on 2025/6/13.
//

import UserNotifications

protocol NotificationSender {
    func sendNotification(id: String, notification: N2SNotification, trigger: UNNotificationTrigger)
}
