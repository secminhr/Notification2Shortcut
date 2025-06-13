//
//  NotificationStorage.swift
//  Notification2Shortcut
//
//  Created by secminhr on 2025/6/13.
//

protocol NotificationStorage {
    /// Notifications available when the NotificationStorage instance is initiated. ``update(_:id:)`` should not modify it, and the modification won't affect anything.
    var initNotifications: [String: N2SNotification] { get async }
    mutating func update(_ notification: N2SNotification, id: String) async
}
