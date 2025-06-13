//
//  NotificationManagerToSender.swift
//  Notification2ShortcutTests
//
//  Created by secminhr on 2025/6/12.
//

import Testing
@testable import Notification2Shortcut
import UserNotifications

struct DumbStorage: NotificationStorage {
    let initNotifications: OrderedDictionary<String, N2SNotification> = [:]
    
    mutating func update(_ notification: Notification2Shortcut.N2SNotification, id: String) {
        // do nothing
    }
}

class SuccessSender: NotificationSender {
    var sentNotifications: [(N2SNotification, UNNotificationTrigger)] = []
    
    func sendNotification(notification: Notification2Shortcut.N2SNotification, trigger: UNNotificationTrigger) {
        sentNotifications.append((notification, trigger))
    }
}

struct FailingSender: NotificationSender {
    enum Error: Swift.Error {
        case err
    }
    func sendNotification(notification: Notification2Shortcut.N2SNotification, trigger: UNNotificationTrigger) async throws {
        throw Error.err
    }
}

struct NotificationManagerToSender {
    @Test func sendNotification() async throws {
        let notification = N2SNotification("Title", notificationSendingId: "sendingId")
        
        let sender = SuccessSender()
        let manager = try await NotificationManager(storage: DumbStorage(), sender: sender)
        try await manager.update(notification, id: "id")
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
        try await manager.sendNotification(id: "id", withTrigger: trigger)
        
        try #require(sender.sentNotifications.count == 1)
        #expect(sender.sentNotifications[0] == (notification, trigger))
    }
    
    @Test func sendNotificationWhenNotExist() async throws {
        let sender = SuccessSender()
        let manager = try await NotificationManager(storage: DumbStorage(), sender: sender)
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
        var caughtError = false
        do {
            try await manager.sendNotification(id: "id", withTrigger: trigger)
        } catch NotificationManager.Error.notificationNotExists {
            caughtError = true
        }
        
        #expect(caughtError)
    }
    
    @Test func SenderFails() async throws {
        let sender = FailingSender()
        let manager = try await NotificationManager(storage: DumbStorage(), sender: sender)
        try await manager.update(N2SNotification(), id: "id")
        
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
        var caughtError = false
        do {
            try await manager.sendNotification(id: "id", withTrigger: trigger)
        } catch NotificationManager.Error.sendNotificationFail(let senderError) {
            caughtError = true
            #expect(senderError as! FailingSender.Error == FailingSender.Error.err)
        }
        
        #expect(caughtError)
    }
}
