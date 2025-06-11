//
//  Item.swift
//  Notification2Shortcut
//
//  Created by secminhr on 2025/6/12.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
