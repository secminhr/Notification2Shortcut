//
//  AsyncThrowsLoadingView.swift
//  Notification2Shortcut
//
//  Created by secminhr on 2025/6/16.
//

import SwiftUI

struct AsyncThrowsLoadingView<R, E: Error, ResultView: View, ErrorView: View>: View {
    @StateObject var viewModel: AsyncThrowsLoadingViewModel<R, E>
    let resultView: (R) -> ResultView
    let errorView: (E) -> ErrorView
    
    init(task: @escaping () async throws(E) -> R,
         @ViewBuilder resultView: @escaping (R) -> ResultView,
         @ViewBuilder errorView: @escaping (E) -> ErrorView) {
        _viewModel = StateObject(wrappedValue: AsyncThrowsLoadingViewModel(task: task))
        self.resultView = resultView
        self.errorView = errorView
    }
    
    var body: some View {
        if viewModel.isLoading {
            ZStack {
                Color.clear
                ProgressView()
            }
            .task(viewModel.load)
        } else if let error = viewModel.error {
            errorView(error)
        } else if let result = viewModel.data {
            resultView(result)
        } else {
            fatalError("Shouldn't happen")
        }
    }
}

extension AsyncThrowsLoadingView where E == Never, ErrorView == EmptyView {
    init(task: @escaping () async throws(Never) -> R,
         @ViewBuilder resultView: @escaping (R) -> ResultView) {
        self.init(task: task, resultView: resultView) { _ in }
    }
}

#Preview("success") {
    AsyncThrowsLoadingView { () async throws(Never) -> String in
        "Hello"
    } resultView: { result in
        ZStack {
            Color.clear
            Text(result)
        }
    }
    errorView: { _ in Text("Error") }
}

private enum PreviewError: Error {
    case err(message: String)
}
#Preview("error") {
    AsyncThrowsLoadingView { () async throws(PreviewError) -> String in
        throw PreviewError.err(message: "Error msg")
    } resultView: { _ in
        Text("Hello")
    } errorView: { error in
        if case .err(let msg) = error {
            ZStack {
                Color.clear
                Text(msg)
            }
        }
    }
}

#Preview("loading") {
    AsyncThrowsLoadingView { () async throws(Never) -> Void in
        await withCheckedContinuation { _ in }
    } resultView: {
        Text("Hello")
    } errorView: { _ in
        Text("Error")
    }
}
