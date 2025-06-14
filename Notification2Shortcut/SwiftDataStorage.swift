//
//  SwiftDataStorage.swift
//  Notification2Shortcut
//
//  Created by secminhr on 2025/6/14.
//

import Foundation
import SwiftData
import N2SPredicates

@Model
class NotificationModel {
    #Index<NotificationModel>([\.notificationId])
    
    @Attribute(.unique) var notificationId: String
    var notificationSendingId: String
    var title: String
    var subtitle: String?
    var body: String?
    
    init(notificationId: String, notificationSendingId: String, title: String, subtitle: String?, body: String?) {
        self.notificationId = notificationId
        self.notificationSendingId = notificationSendingId
        self.title = title
        self.subtitle = subtitle
        self.body = body
    }
}

struct SwiftDataStorage: NotificationStorage {
    private let modelContext: ModelContext
    var initNotifications: [N2SNotification]
    
    init(modelContext: ModelContext) throws {
        self.modelContext = modelContext
        initNotifications = try modelContext.fetch(FetchDescriptor<NotificationModel>())
            .map { $0.toN2SNotification() }
    }
    
    mutating func update(_ notification: N2SNotification) throws {
        let descriptor = FetchDescriptor<NotificationModel>(
            predicate: Equals(keyPath: \.notificationId, str: notification.id)
        )
        
        if let model = try modelContext.fetch(descriptor).first {
            model.notificationSendingId = notification.notificationSendingId
            model.title = notification.title
            model.subtitle = notification.subtitle
            model.body = notification.body
        } else {
            modelContext.insert(notification.toNotificationModel())
        }
        
        try modelContext.save()
    }
}

extension NotificationModel {
    func toN2SNotification() -> N2SNotification {
        var notification = N2SNotification(title,
                                           notificationSendingId: notificationSendingId,
                                           id: notificationId)
        notification.subtitle = subtitle
        notification.body = body
        
        return notification
    }
}

extension N2SNotification {
    func toNotificationModel() -> NotificationModel {
        return NotificationModel(notificationId: id,
                                 notificationSendingId: notificationSendingId,
                                 title: title,
                                 subtitle: subtitle,
                                 body: body)
    }
}

