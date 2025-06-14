//
//  ContentView.swift
//  Notification2Shortcut
//
//  Created by secminhr on 2025/6/12.
//

import SwiftUI
import SwiftData
import UserNotifications

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    var viewModel: NotificationsViewModel?
    
    var body: some View {
        if viewModel != nil {
            @Bindable var model = viewModel!
            NavigationSplitView {
                List(model.notifications, selection: $model.selectedId) { notification in
                    NavigationLink(value: notification.id) {
                        Text(notification.title)
                    }
                }
            } detail: {
                if let notification = model.selectedNotification {
                    Text(notification.title)
                } else {
                    ProgressView()
                }
            }
            .toolbar {
                ToolbarItem {
                    Button("New", systemImage: "plus") {
                        Task {
                            try? await model.newNotification()
                        }
                    }
                    .labelStyle(.iconOnly)
                }
            }
        } else {
            ProgressView()
        }
    }
}

struct ConstStorage: NotificationStorage {
    var initNotifications: [N2SNotification] = [
        N2SNotification("Title1"),
        N2SNotification("Title2"),
        N2SNotification("Title3")
    ]
    
    mutating func update(_ notification: N2SNotification) async throws {
        // do nothing
    }
}

#Preview {
    struct AsyncView: View {
        @State var viewModel: NotificationsViewModel? = nil
        var body: some View {
            ContentView(viewModel: viewModel)
                .modelContainer(for: Item.self, inMemory: true)
                .task {
                    let manager = try! await NotificationManager(storage: ConstStorage(), sender: UNSender())
                    viewModel = NotificationsViewModel(notificationManager: manager)
                }
        }
    }
    
    return AsyncView()
}
