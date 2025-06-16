//
//  ViewModelHolder.swift
//  Notification2Shortcut
//
//  Created by secminhr on 2025/6/15.
//

import SwiftUI
import SwiftData

struct NotificationsViewModelLoadingView: View {
    @Environment(\.modelContext) private var context: ModelContext
    
    var body: some View {
        AsyncThrowsLoadingView {
            let storage = try SwiftDataStorage(modelContext: context)
            let manager = try await NotificationManager(storage: storage, sender: UNSender())
            return NotificationsViewModel(notificationManager: manager)
        } resultView: { viewModel in
            MainView(viewModel: viewModel)
        } errorView: { _ in
            Text("Error while loading data...")
        }
    }
}

#Preview {
    NotificationsViewModelLoadingView()
        .modelContainer(for: NotificationModel.self, inMemory: true)
}
