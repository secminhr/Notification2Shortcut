//
//  AsyncThrowsLoadingViewModel.swift
//  Notification2ShortcutTests
//
//  Created by secminhr on 2025/6/16.
//

import Foundation
import Combine


class AsyncThrowsLoadingViewModel<R, E: Error>: ObservableObject {
    @Published private(set) var isLoading = true
    @Published private(set) var error: E? = nil
    @Published private(set) var data: R? = nil
    
    private var task: () async throws(E) -> R
    
    init(task: @escaping () async throws(E) -> R) {
        self.task = task
    }
    
    func load() async {
        do throws(E) {
            self.data = try await task()
        } catch {
            self.error = error
        }
        self.isLoading = false
    }
}
