//
//  N2SNotificationTest.swift
//  Notification2ShortcutTests
//
//  Created by secminhr on 2025/6/13.
//

import Testing
@testable import Notification2Shortcut

struct N2SNotificationTest {

    @Test func testDefaultTitle() async throws {
        let notification = N2SNotification()
        
        #expect(notification.title == "Title")
        #expect(notification.subtitle == nil)
        #expect(notification.body == nil)
    }
    
    @Test func testCustomTitle() async throws {
        let notification = N2SNotification("Custom Title")
        
        #expect(notification.title == "Custom Title")
        #expect(notification.subtitle == nil)
        #expect(notification.body == nil)
    }
}
