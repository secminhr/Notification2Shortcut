//
//  ContentView.swift
//  Notification2Shortcut
//
//  Created by secminhr on 2025/6/12.
//

import SwiftUI
import SwiftData
import UserNotifications

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]

    @State private var title: String = ""
    var body: some View {
        
        VStack {
            TextField("Title", text: $title)
            Button("Send") {
                let content = UNMutableNotificationContent()
                content.title = title
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
                let request = UNNotificationRequest(identifier: "test", content: content, trigger: trigger)
                
                let center = UNUserNotificationCenter.current()
                center.requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
                    if granted {
                        center.add(request) { addError in
                            if let addError = addError {
                                print("Failed to add notification: \(addError.localizedDescription)")
                            }
                        }
                    } else if let error = error {
                        print("Authorization error: \(error.localizedDescription)")
                    }
                }
            }
        }
    }

    private func addItem() {
        withAnimation {
            let newItem = Item(timestamp: Date())
            modelContext.insert(newItem)
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
