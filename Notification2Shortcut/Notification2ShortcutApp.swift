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
            NotificationModel.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    
    var body: some Scene {
        WindowGroup {
            ViewModelHolder()
        }
        .modelContainer(sharedModelContainer)
    }
}

struct ViewModelHolder: View {
    @Environment(\.modelContext) private var context: ModelContext
    @State var viewModel: NotificationsViewModel? = nil
    @State var errorDuringLoading: Bool = false
    
    var body: some View {
        if !errorDuringLoading {
            ContentView(viewModel: viewModel)
                .task {
                    do {
                        let storage = try SwiftDataStorage(modelContext: context)
                        let manager = try await NotificationManager(storage: storage, sender: UNSender())
                        viewModel = NotificationsViewModel(notificationManager: manager)
                    } catch {
                        errorDuringLoading = true
                    }
                }
        } else {
            Text("Error while loading data...")
        }
    }
}
