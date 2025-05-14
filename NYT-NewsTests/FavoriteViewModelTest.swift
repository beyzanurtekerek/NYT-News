//
//  FavoriteViewModelTest.swift
//  NYT-NewsTests
//
//  Created by Beyza Nur Tekerek on 10.05.2025.
//

import XCTest
@testable import NYT_News

class FavoriteViewModelTests: XCTestCase {
    
    var viewModel: FavoriteViewModel!
    var mockDelegate: MockFavoriteViewModelDelegate!
    
    override func setUp() {
        super.setUp()
        let mockPersistence = MockDataPersistenceManager()
        viewModel = FavoriteViewModel(dataPersistence: mockPersistence)
        mockDelegate = MockFavoriteViewModelDelegate()
        viewModel.delegate = mockDelegate
        
        let mockArticle = SavedArticle(context: DataPersistenceManager.shared.persistentContainer.viewContext)
        mockArticle.title = "Test Article"
        mockPersistence.savedArticles = [mockArticle]
    }
    
    override func tearDown() {
        viewModel = nil
        mockDelegate = nil
        super.tearDown()
    }
    
    func testFetchSavedArticles() {
        let expectation = self.expectation(description: "Delegate method should be called after fetching saved articles")
        viewModel.fetchSavedArticles()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertTrue(self.mockDelegate.didUpdateArticlesCalled, "Delegate method should be called after fetching saved articles.")
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 2, handler: nil)
    }
    //    func testSaveArticle() {
    //        if let article = viewModel.savedArticles.first {
    //            viewModel.toggleSaveStatus(for: article, indexPath: IndexPath(row: 0, section: 0))
    //            XCTAssertTrue(mockDelegate.showToastCalled, "ShowToast should be called when article is saved successfully.")
    //        } else {
    //            XCTFail("No saved articles to delete.")
    //        }
    //    }
    //
    //    func testDeleteArticle() {
    //        if let article = viewModel.savedArticles.first {
    //            viewModel.toggleSaveStatus(for: article, indexPath: IndexPath(row: 0, section: 0))
    //            XCTAssertTrue(mockDelegate.showToastCalled, "ShowToast should be called when article is unsaved successfully.")
    //        } else {
    //            XCTFail("No saved articles to delete.")
    //        }
    //    }
}

// Mock Delegate
class MockFavoriteViewModelDelegate: FavoriteViewModelDelegate {
    var didFetchSavedArticlesCalled = false
    var fetchedArticles: [SavedArticle] = []
    
    var didUpdateArticlesCalled = false
    var showToastCalled = false
    
    func didFetchSavedArticles(_ articles: [SavedArticle]) {
        didFetchSavedArticlesCalled = true
        fetchedArticles = articles
    }
    
    func didUpdateArticles() {
        didUpdateArticlesCalled = true
    }
    
    func showToast(message: String) {
        showToastCalled = true
    }
}
