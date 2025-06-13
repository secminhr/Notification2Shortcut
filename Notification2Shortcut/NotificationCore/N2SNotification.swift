//
//  N2SNotification.swift
//  Notification2Shortcut
//
//  Created by secminhr on 2025/6/13.
//

import Foundation

@propertyWrapper
struct NonEmpty {
    private let defaultValue: String
    private var value: String
    
    init(defaultValue: String) {
        self.defaultValue = defaultValue
        self.value = defaultValue
    }
    
    var wrappedValue: String {
        get { return value }
        set {
            if newValue.isEmpty {
                value = defaultValue
            } else {
                value = newValue
            }
        }
    }
}

struct N2SNotification: Equatable {
    static func == (lhs: N2SNotification, rhs: N2SNotification) -> Bool {
        return  lhs.notificationSendingId == rhs.notificationSendingId &&
                lhs.title == rhs.title &&
                lhs.subtitle == rhs.subtitle &&
                lhs.body == rhs.body
    }
    
    var notificationSendingId: String
    @NonEmpty(defaultValue: "Title") var title: String
    var subtitle: String? = nil
    var body: String? = nil
    
    init(_ title: String = "", notificationSendingId: String = UUID().uuidString) {
        self.notificationSendingId = notificationSendingId
        self.title = title
    }
}
