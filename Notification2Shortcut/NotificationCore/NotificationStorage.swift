//
//  NotificationStorage.swift
//  Notification2Shortcut
//
//  Created by secminhr on 2025/6/13.
//

protocol NotificationStorage {
    var notifications: [Notification] { get }
    mutating func add(_ notification: Notification)
}
