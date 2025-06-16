//
//  NotificationEditor.swift
//  Notification2Shortcut
//
//  Created by secminhr on 2025/6/16.
//

import SwiftUI

struct NotificationEditor: View {
    var notification: N2SNotification
    
    init(_ notification: N2SNotification) {
        self.notification = notification
    }
    var body: some View {
        VStack {
            Text(notification.title)
            Text(notification.id)
        }
    }
}

#Preview {
    NotificationEditor(N2SNotification("Title1"))
}
