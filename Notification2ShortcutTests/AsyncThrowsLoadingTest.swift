//
//  AsyncThrowsLoadingTest.swift
//  Notification2ShortcutTests
//
//  Created by secminhr on 2025/6/16.
//

import Testing

struct AsyncThrowsLoadingTest {
    
    @Test func testInitialState() async throws {
        let viewModel = AsyncThrowsLoadingViewModel<Void, Never> { () in
            
        }
        
        #expect(viewModel.isLoading)
        #expect(viewModel.error == nil)
        #expect(viewModel.data == nil)
    }
    

    @Test func testSuccess() async throws {
        let viewModel = AsyncThrowsLoadingViewModel<Int, Never> {
            5
        }
        
        await viewModel.load()
        
        #expect(viewModel.isLoading == false)
        #expect(viewModel.error == nil)
        #expect(viewModel.data == 5)
    }
    
    enum TestError: Error, Equatable {
        case err
        case errVal(String)
    }
    
    @Test func testFailureNoAssociatedValue() async throws {
        let viewModel = AsyncThrowsLoadingViewModel<Void, TestError> { () async throws(TestError) -> Void in
            throw TestError.err
        }
        
        await viewModel.load()
        
        #expect(viewModel.isLoading == false)
        #expect(viewModel.error == TestError.err)
        #expect(viewModel.data == nil)
    }
    
    @Test func testFailureWithAssociatedValue() async throws {
        let viewModel = AsyncThrowsLoadingViewModel<Void, TestError> { () async throws(TestError) -> Void in
            throw TestError.errVal("test")
        }
        
        await viewModel.load()
        
        #expect(viewModel.isLoading == false)
        #expect(viewModel.error == .errVal("test"))
        #expect(viewModel.data == nil)
    }
}
