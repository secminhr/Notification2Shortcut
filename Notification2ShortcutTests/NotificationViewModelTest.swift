//
//  NotificationViewModelTest.swift
//  Notification2ShortcutTests
//
//  Created by secminhr on 2025/6/14.
//

import Testing
import OrderedCollections
@testable import Notification2Shortcut

struct NotificationViewModelTest {
    
    @Test func changeSelection() async throws {
        let notification = N2SNotification(id: "1")
        let manager = try await NotificationManager(storage: InMemoryStorage([notification]), sender: DumbSender())
        let viewModel = NotificationsViewModel(notificationManager: manager)
        #expect(viewModel.selectedNotification == nil)
        
        viewModel.selectedId = "1"
        #expect(viewModel.selectedNotification == notification)
    }
    
    @Test func newNotification() async throws {
        let storage = InMemoryStorage()
        let manager = try await NotificationManager(storage: storage, sender: DumbSender())
        let viewModel = NotificationsViewModel(notificationManager: manager)
        
        try await viewModel.newNotification()
        
        try #require(storage.notifications.count == 1)
        try await viewModel.newNotification()
        
        try #require(storage.notifications.count == 2)
        #expect(viewModel.selectedNotification == storage.notifications[viewModel.selectedId!])
    }
}
