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

    @Test func initializeNotifications() async throws {
        let existingNotifications: [N2SNotification] = [
            N2SNotification(id: "1"),
            N2SNotification(id: "2"),
        ]
        let manager = try await NotificationManager(storage: InMemoryStorage(existingNotifications), sender: DumbSender())
        
        let viewModel = NotificationsViewModel(notificationManager: manager)
        #expect(viewModel.notifications == existingNotifications)
    }
    
    @Test func initWithEmptyStorage() async throws {
        let manager = try await NotificationManager(storage: DumbStorage(), sender: DumbSender())
        
        let viewModel = NotificationsViewModel(notificationManager: manager)
        #expect(viewModel.notifications == [])
    }
    
    @Test func changeSelection() async throws {
        let notification = N2SNotification(id: "1")
        let manager = try await NotificationManager(storage: InMemoryStorage([notification]), sender: DumbSender())
        let viewModel = NotificationsViewModel(notificationManager: manager)
        #expect(viewModel.selectedNotification == nil)
        
        viewModel.selectedId = "1"
        #expect(viewModel.selectedNotification == notification)
    }
    
    @Test func newNotification() async throws {
        let manager = try await NotificationManager(storage: DumbStorage(), sender: DumbSender())
        let viewModel = NotificationsViewModel(notificationManager: manager)
        
        try await viewModel.newNotification()
        try #require(viewModel.notifications.count == 1)
        try await viewModel.newNotification()
        
        try #require(viewModel.notifications.count == 2)
        #expect(viewModel.selectedNotification == viewModel.notifications[1])
    }
}
