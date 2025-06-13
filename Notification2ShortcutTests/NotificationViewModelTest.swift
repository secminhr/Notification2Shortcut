//
//  NotificationViewModelTest.swift
//  Notification2ShortcutTests
//
//  Created by secminhr on 2025/6/14.
//

import Testing
@testable import Notification2Shortcut

struct NotificationViewModelTest {

    @Test func initializeNotifications() async throws {
        let existingNotifications: OrderedDictionary<String, N2SNotification> = [
            "1": N2SNotification(),
            "2": N2SNotification(),
        ]
        let manager = try await NotificationManager(storage: InMemoryStorage(existingNotifications), sender: DumbSender())
        
        let viewModel = NotificationsViewModel(notificationManager: manager)
        #expect(viewModel.notificationIds == ["1", "2"])
    }
    
    @Test func initWithEmptyStorage() async throws {
        let manager = try await NotificationManager(storage: DumbStorage(), sender: DumbSender())
        
        let viewModel = NotificationsViewModel(notificationManager: manager)
        #expect(viewModel.notificationIds == [])
    }
    
    @Test func changeSelection() async throws {
        let notification = N2SNotification()
        let manager = try await NotificationManager(storage: InMemoryStorage(["1": notification]), sender: DumbSender())
        var viewModel = NotificationsViewModel(notificationManager: manager)
        #expect(viewModel.selectedNotification == nil)
        
        viewModel.selectedIndex = 0
        #expect(viewModel.selectedNotification == notification)
    }
    
    // TODO: newNotification is not tested. I'll first see if it works in actual app
}
