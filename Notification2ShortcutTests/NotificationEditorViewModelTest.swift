//
//  NotificationEditorViewModelTest.swift
//  Notification2ShortcutTests
//
//  Created by secminhr on 2025/6/19.
//

import Testing
@preconcurrency import Combine
@testable import Notification2Shortcut
import Foundation

class MockManager: NotificationManager {
    // this represent how many times update is called by storing the argument for each call
    var updateArguments: [N2SNotification] = []
    init() async {
        try! await super.init(storage: DumbStorage(), sender: DumbSender())
    }
    
    
    override func update(_ notification: N2SNotification) async throws {
        updateArguments.append(notification)
    }
}

class FailUpdateMockManager: MockManager {
    enum Error: Swift.Error {
        case fail
    }
    
    private var failTimes: Int
    init(times: Int) async {
        failTimes = times
        await super.init()
    }
    
    override func update(_ notification: N2SNotification) async throws {
        try await super.update(notification)  // we still want to record the calls
        if failTimes > 0 {
            failTimes -= 1
            throw Error.fail
        }
    }
}

struct NotificationEditorViewModelTest {
    
    @Test func testNotEditing() async throws {
        let manager = await MockManager()
        let viewModel = NotificationEditorViewModel(manager)
        
        try #require(!viewModel.isEditing)
        
        viewModel.title = "aabbcc"
        #expect(manager.updateArguments.isEmpty)
    }
    
    @Test func testSetEditing() async throws {
        let manager = await MockManager()
        let notification = N2SNotification()
        let viewModel = NotificationEditorViewModel(manager)
        
        async let result = viewModel.$saveError
            .dropFirst() // drop init value
            .async()
        try await Task.sleep(nanoseconds: 100)
        
        viewModel.setEditing(notification: notification)
        try #require(viewModel.isEditing)
        
        viewModel.title = "Title1"
        #expect(await result == false)
        try #require(manager.updateArguments.count == 1)
        #expect(manager.updateArguments[0].title == "Title1")
    }
    
    
    @Test func testEdit() async throws {
        let manager = await MockManager()
        let notification = N2SNotification()
        let viewModel = NotificationEditorViewModel(manager, editing: notification)
        
        async let result = viewModel.$saveError
            .dropFirst() // drop init value
            .async()
        try await Task.sleep(nanoseconds: 100)  // wait for subscription ready, TODO: find a better way
        
        viewModel.title = "Title22"
        viewModel.subtitle = "subtitle"
        viewModel.body = "Body"
        viewModel.sendingId = "sid"
        
        #expect(await result == false)
        try #require(manager.updateArguments.count == 4)
        #expect(manager.updateArguments[3].id == notification.id)
        #expect(manager.updateArguments[3].title == "Title22")
        #expect(manager.updateArguments[3].subtitle == "subtitle")
        #expect(manager.updateArguments[3].body == "Body")
        #expect(manager.updateArguments[3].notificationSendingId == "sid")
    }
    
    @Test func testEditFailure() async throws {
        let manager = await FailUpdateMockManager(times: 10)
        let notification = N2SNotification()
        let viewModel = NotificationEditorViewModel(manager, editing: notification)
        
        async let error = viewModel.$saveError
            .dropFirst() // drop init value
            .async()
        try await Task.sleep(nanoseconds: 100)  // wait for subscription ready
        
        viewModel.title = "EditThatFails"
        
        #expect(await error == true)
    }
    
    @Test func testFailureRetry() async throws {
        let manager = await FailUpdateMockManager(times: 5)
        let notification = N2SNotification()
        let viewModel = NotificationEditorViewModel(manager, editing: notification, retrySave: 6)
        
        async let error = viewModel.$saveError
            .dropFirst()
            .async()
        try await Task.sleep(nanoseconds: 100)
        
        viewModel.title = "Edit"
        #expect(await error == false)
        try #require(manager.updateArguments.count == 6)
        #expect(manager.updateArguments[0].title == "Edit")
        #expect(manager.updateArguments[0].id == notification.id)
        #expect(manager.updateArguments[1].title == "Edit")
        #expect(manager.updateArguments[1].id == notification.id)
        #expect(manager.updateArguments[2].title == "Edit")
        #expect(manager.updateArguments[2].id == notification.id)
        #expect(manager.updateArguments[3].title == "Edit")
        #expect(manager.updateArguments[3].id == notification.id)
    }

}

extension Publisher where Failure == Never, Output: Sendable {
    func async() async -> Output {
        // make cancellable "local to async function", to avoid being released too early
        var cancellable: AnyCancellable?
        
        return await withCheckedContinuation { continuation in
            cancellable = self.sink { value in
                continuation.resume(returning: value)
                cancellable?.cancel()
            }
        }
    }
}
