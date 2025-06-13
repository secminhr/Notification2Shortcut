//
//  OrderedDictionary.swift
//  Notification2Shortcut
//
//  Created by secminhr on 2025/6/14.
//

import Foundation

struct OrderedDictionary<K: Hashable, V>: ExpressibleByDictionaryLiteral {
    private(set) var keys: [K]
    private var dictionary: [K: V]
    
    init(dictionaryLiteral elements: (K, V)...) {
        keys = elements.map(\.0)
        dictionary = [:]
        
        for (k, v) in elements {
            dictionary[k] = v
        }
    }
    
    subscript(key: K) -> V? {
        get {
            dictionary[key]
        }
        set {
            if let newValue = newValue {
                dictionary[key] = newValue
                if !keys.contains(key) {
                    keys.append(key)
                }
            } else {
                dictionary[key] = nil
                keys.removeAll { $0 == key }
            }
        }
    }
}

extension OrderedDictionary {
    func toDictionary() -> [K: V] {
        return dictionary
    }
}
