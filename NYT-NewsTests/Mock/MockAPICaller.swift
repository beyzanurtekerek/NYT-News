//
//  MockAPICaller.swift
//  NYT-NewsTests
//
//  Created by Beyza Nur Tekerek on 10.05.2025.
//

import Foundation
@testable import NYT_News

final class MockAPICaller: APICaller {

    var shouldReturnError = false
    var mockNews: [New] = []
    var mockDocs: [Doc] = []

    override func getTopStories(for category: String, completion: @escaping (Result<[New], Error>) -> Void) {
        if shouldReturnError {
            completion(.failure(APIError.failedToGetData))
        } else {
            completion(.success(mockNews))
        }
    }

    override func search(with query: String, completion: @escaping (Result<[Doc], Error>) -> Void) {
        if shouldReturnError {
            completion(.failure(APIError.failedToGetData))
        } else {
            completion(.success(mockDocs))
        }
    }
}
