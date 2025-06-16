//
//  ViewModelHolder.swift
//  Notification2Shortcut
//
//  Created by secminhr on 2025/6/15.
//

import SwiftUI
import SwiftData

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
