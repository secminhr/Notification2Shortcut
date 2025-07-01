//
//  NotificationEditor.swift
//  Notification2Shortcut
//
//  Created by secminhr on 2025/6/16.
//

import SwiftUI

struct NotificationEditor: View {
    @StateObject private var viewModel: NotificationEditorViewModel
    private let currentEditing: N2SNotification
    
    init(_ notification: N2SNotification, _ manager: NotificationManager) {
        _viewModel = StateObject(wrappedValue: NotificationEditorViewModel(manager))
        
        currentEditing = notification
    }
    
    @State private var editingTitle = false
    
    var body: some View {
        GeometryReader { geometry in
            let totalWidth = min(geometry.size.width, 480) // 我們仍維持最大寬度
            let iconWidth = totalWidth / 9

            HStack(alignment: .center, spacing: 12) {
                Image(systemName: "bell.fill")
                    .resizable()
                    .aspectRatio(1, contentMode: .fit)
                    .frame(width: iconWidth, height: iconWidth)
                    .clipShape(RoundedRectangle(cornerRadius: iconWidth * 0.2, style: .continuous))

                VStack(alignment: .leading, spacing: 4) {
                    HStack(alignment: .firstTextBaseline) {
                        VStack(alignment: .leading, spacing: 2) {
                            if editingTitle {
                                TextField(text: $viewModel.title) {
                                    
                                }
                                .onSubmit {
                                    editingTitle = false
                                }
                            } else {
                                Text(viewModel.title)
                                    .font(.system(size: 17, weight: .semibold))
                                    .foregroundStyle(.primary)
                                    .onTapGesture {
                                        editingTitle = true
                                    }
                            }
                            Text(viewModel.subtitle)
                                .font(.system(size: 17, weight: .semibold))
                                .foregroundStyle(.primary)
                        }

                        Spacer()

                        Text("now")
                            .font(.system(size: 13))
                            .foregroundStyle(.secondary)
                    }

                    Text(viewModel.body)
                        .font(.system(size: 15))
                        .lineLimit(3)
                }
            }
            .padding(16)
            .frame(width: totalWidth, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 28, style: .continuous)
                    .fill(.ultraThinMaterial)
            )
            .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
            .shadow(radius: 8)
            .position(CGPoint(x: geometry.frame(in: .local).midX, y: geometry.frame(in: .local).midY))
        }
        .frame(maxWidth: 480, minHeight: 80)
        .onAppear {
            viewModel.setEditing(notification: currentEditing)
        }
    }
}


#Preview {
    AsyncThrowsLoadingView {
        let manager = try! await NotificationManager(storage: ConstStorage(), sender: UNSender())
        var notification = N2SNotification("Title11")
        notification.subtitle = "subtitle"
        notification.body = "body"
        notification.notificationSendingId = "123"
        return (manager, notification)
    } resultView: { (manager, notification) in
        ZStack {
            LinearGradient(
                colors: [.blue, .purple, .pink],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            NotificationEditor(notification, manager)
        }
        .frame(width: 300)
    } errorView: { _ in
        Text("kkkkkkkkkk")
    }
}

#Preview("Long body") {
    AsyncThrowsLoadingView {
        let manager = try! await NotificationManager(storage: ConstStorage(), sender: UNSender())
        var notification = N2SNotification("Title11")
        notification.subtitle = "subtitle"
        notification.body = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum"
        notification.notificationSendingId = "123"
        return (manager, notification)
    } resultView: { (manager, notification) in
        ZStack {
            LinearGradient(
                colors: [.blue, .purple, .pink],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            NotificationEditor(notification, manager)
        }
        .frame(width: 300)
    } errorView: { _ in
        Text("kkkkkkkkkk")
    }
}
