//
//  ContentView.swift
//  Notification2Shortcut
//
//  Created by secminhr on 2025/6/12.
//

import SwiftUI
import SwiftData
import UserNotifications

struct MainView: View {
    @Environment(\.modelContext) private var modelContext
    @Bindable var viewModel: NotificationsViewModel
    
    var body: some View {
        NavigationSplitView {
            List(viewModel.notifications, selection: $viewModel.selectedId) { notification in
                NavigationLink(value: notification.id) {
                    Text(notification.title)
                }
            }
        } detail: {
            if let notification = viewModel.selectedNotification {
                NotificationEditor(notification)
            } else {
                Text("Select a notification")
            }
        }
        .toolbar {
            ToolbarItem {
                Button("New", systemImage: "plus") {
                    Task {
                        try? await viewModel.newNotification()
                    }
                }
                .labelStyle(.iconOnly)
            }
        }
    }
}

struct ConstStorage: NotificationStorage {
    var initNotifications: [N2SNotification]
    
    init(_ initNotifications: [N2SNotification] = [
        N2SNotification("Title1"),
        N2SNotification("Title2"),
        N2SNotification("Title3")
    ]) {
        self.initNotifications = initNotifications
    }
    
    mutating func update(_ notification: N2SNotification) async throws {
        // do nothing
    }
}

#Preview {
    AsyncThrowsLoadingView {
        let manager = try! await NotificationManager(storage: ConstStorage(), sender: UNSender())
        return NotificationsViewModel(notificationManager: manager)
    } resultView: { viewModel in
            MainView(viewModel: viewModel)
    } errorView: { error in
            Text("Error")
    }
}

#Preview("no notifications") {
    AsyncThrowsLoadingView {
        let manager = try! await NotificationManager(storage: ConstStorage([]), sender: UNSender())
        return NotificationsViewModel(notificationManager: manager)
    } resultView: { viewModel in
            MainView(viewModel: viewModel)
    } errorView: { error in
            Text("Error")
    }
}
