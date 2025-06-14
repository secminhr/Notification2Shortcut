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

struct N2SNotification: Equatable, Identifiable {
    static func == (lhs: N2SNotification, rhs: N2SNotification) -> Bool {
        return lhs.id == rhs.id
    }
    
    let id: String
    var notificationSendingId: String
    @NonEmpty(defaultValue: "Title") var title: String
    var subtitle: String? = nil
    var body: String? = nil
    
    init(_ title: String = "", notificationSendingId: String = UUID().uuidString, id: String = UUID().uuidString) {
        self.id = id
        self.notificationSendingId = notificationSendingId
        self.title = title
    }
}
