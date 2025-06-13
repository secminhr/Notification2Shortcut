//
//  NotificationStorage.swift
//  Notification2Shortcut
//
//  Created by secminhr on 2025/6/13.
//

protocol NotificationStorage {
    var notifications: [N2SNotification] { get }
    mutating func update(_ notification: N2SNotification, id: String)
}
