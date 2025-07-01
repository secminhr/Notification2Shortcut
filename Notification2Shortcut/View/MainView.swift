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
    @State var newNotificationFailed: Bool = false
    
    @Query var notifications: [NotificationModel]
    
    var body: some View {
        NavigationSplitView {
            List(notifications, selection: $viewModel.selectedId) { notification in
                NavigationLink(value: notification.notificationId) {
                    Text(notification.title)
                }
            }
        } detail: {
            if let notification = viewModel.selectedNotification {
                NotificationEditor(notification, viewModel.notificationManager)
                    .padding(.horizontal)
            } else {
                Text("Create or select a notification")
            }
        }
        .toolbar {
            ToolbarItem {
                Button("New", systemImage: "plus") {
                    Task {
                        do {
                            try await viewModel.newNotification()
                        } catch {
                            newNotificationFailed = true
                        }
                    }
                }
                .labelStyle(.iconOnly)
                .popover(isPresented: $newNotificationFailed) {
                    Text("Creating new notification failed.")
                        .padding(.all)
                }
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
        let viewModel = NotificationsViewModel(notificationManager: manager)
        
        let container = try! ModelContainer(for: NotificationModel.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
        container.mainContext.insert(NotificationModel(notificationId: "1", notificationSendingId: "1", title: "Title1", subtitle: "Subtitle1", body: "body1"))
        try! container.mainContext.save()
        container.mainContext.insert(NotificationModel(notificationId: "2", notificationSendingId: "2", title: "Title2", subtitle: "Subtitle2", body: "body2"))
        try! container.mainContext.save()
        container.mainContext.insert(NotificationModel(notificationId: "3", notificationSendingId: "3", title: "Title3", subtitle: "Subtitle3", body: "body3"))
        try! container.mainContext.save()
        
        return (viewModel, container)
    } resultView: { (viewModel, container) in
            MainView(viewModel: viewModel)
            .modelContainer(container)
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
            .modelContainer(for: NotificationModel.self, inMemory: true)
    } errorView: { error in
            Text("Error")
    }
}

struct FailingStorage: NotificationStorage {
    enum StorageError: Error {
        case err
    }
    var initNotifications: [N2SNotification] = []
    
    mutating func update(_ notification: N2SNotification) async throws {
        throw StorageError.err
    }
}
#Preview("new notification fail") {
    AsyncThrowsLoadingView {
        let manager = try! await NotificationManager(storage: FailingStorage(), sender: UNSender())
        return NotificationsViewModel(notificationManager: manager)
    } resultView: { viewModel in
            MainView(viewModel: viewModel)
            .modelContainer(for: NotificationModel.self, inMemory: true)
    } errorView: { error in
            Text("Error")
    }
}
