//
//  NotificationManager.swift
//  Notification2Shortcut
//
//  Created by secminhr on 2025/6/13.
//

struct NotificationManager {
    private var storage: NotificationStorage
    init(storage: NotificationStorage) {
        self.storage = storage
    }
    
    mutating func add(_ notification: Notification) {
        storage.add(notification)
    }
}
