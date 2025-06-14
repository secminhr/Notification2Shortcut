//
//  Notification2ShortcutApp.swift
//  Notification2Shortcut
//
//  Created by secminhr on 2025/6/12.
//

import SwiftUI
import SwiftData

private class InMemoryStorage: NotificationStorage {
    let initNotifications: [N2SNotification]
    var notifications: [String: N2SNotification]
    
    init(_ notifications: [N2SNotification] = []) {
        self.initNotifications = notifications
        self.notifications = [:]
        for notification in notifications {
            self.notifications[notification.id] = notification
        }
    }
    
    func update(_ notification: N2SNotification) async {
        notifications[notification.id] = notification
    }
}

@main
struct Notification2ShortcutApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    @State var viewModel: NotificationsViewModel? = nil
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: viewModel)
                .task {
                    let manager = try! await NotificationManager(storage: InMemoryStorage(), sender: UNSender())
                    viewModel = NotificationsViewModel(notificationManager: manager)
                }
        }
        .modelContainer(sharedModelContainer)
    }
}
