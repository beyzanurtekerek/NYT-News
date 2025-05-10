//
//  NYT_NewsTests.swift
//  NYT-NewsTests
//
//  Created by Beyza Nur Tekerek on 10.05.2025.
//

import XCTest
@testable import NYT_News

final class HomeViewModelTest: XCTestCase {
    private var viewModel: HomeViewModel!
    private var mockAPI: MockAPICaller!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        mockAPI = MockAPICaller()
        viewModel = HomeViewModel(apiCaller: mockAPI)
    }
    
    override func tearDownWithError() throws {
        viewModel = nil
        mockAPI = nil
        try super.tearDownWithError()
    }
    
    func testBreakingNewsItemOutOfBooundsReturnsNil() {
        viewModel.breakingNews = []
        let result = viewModel.breakingNewsItem(at: 0)
        XCTAssertNil(result, "breakingNewsItem(at:) should return nil if index is out of bounds")
    }
    
    func testRecommendationItemOutOfBoundsReturnsNil() {
        viewModel.recommendations = []
        let result = viewModel.recommendationItem(at: 0)
        XCTAssertNil(result, "recommendationItem(at:) should return nil if index is out of bounds")
    }
    
    func testFetchBreakingNewsSuccess() {
        let expectedTitle = "Mock Headline"
        mockAPI.mockNews = [
            New(
                section: "Tech",
                title: expectedTitle,
                abstract: "This is a mock abstract",
                url: "https://www.nytimes.com/",
                byline: "John Doe",
                published_date: "10-05-2025",
                multimedia: []
            )
        ]
        let expectation = self.expectation(description: "fetchBreakingNews")

        viewModel.fetchBreakingNews { _ in
            XCTAssertEqual(self.viewModel.breakingNews.first?.title, expectedTitle)
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1)
    }
}
