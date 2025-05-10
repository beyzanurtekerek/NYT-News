//
//  MockDataPersistenceManager.swift
//  NYT-NewsTests
//
//  Created by Beyza Nur Tekerek on 10.05.2025.
//

import Foundation
import CoreData
@testable import NYT_News

class MockDataPersistenceManager: DataPersistenceManager {

    // Mock veri
    var savedArticles: [SavedArticle] = []
    
    // Gecici NSPersistentContainer
    private lazy var mockPersistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "NYT_News")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Unresolved error \(error), \(error.localizedDescription)")
            }
        }
        return container
    }()

    private var context: NSManagedObjectContext {
        return mockPersistentContainer.viewContext
    }

    override func saveArticle(from new: New, completion: @escaping (Result<Void, Error>) -> Void) {
        let article = SavedArticle(context: context)
        article.title = new.title
        article.abstractText = new.abstract
        article.url = new.url
        article.imageUrl = new.multimedia?.first?.url ?? ""
        article.publishedDate = new.published_date
        article.section = new.section
        article.byline = new.byline
        article.source = "new"
        savedArticles.append(article)
        completion(.success(()))
    }

    override func saveArticle(from doc: Doc, completion: @escaping (Result<Void, Error>) -> Void) {
        let article = SavedArticle(context: context)
        article.title = doc.headline.main
        article.abstractText = doc.abstract
        article.url = doc.web_url
        article.imageUrl = doc.multimedia.multimediaDefault?.url ?? ""
        article.publishedDate = doc.pub_date
        article.section = doc.section_name
        article.byline = doc.byline.original
        article.source = "doc"
        savedArticles.append(article)
        completion(.success(()))
    }

    override func fetchSavedArticles(completion: @escaping (Result<[SavedArticle], Error>) -> Void) {
        completion(.success(savedArticles))
    }

    override func deleteArticle(from article: New, completion: @escaping (Result<Void, Error>) -> Void) {
        savedArticles.removeAll { $0.title == article.title }
        completion(.success(()))
    }

    override func deleteArticle(from article: Doc, completion: @escaping (Result<Void, Error>) -> Void) {
        savedArticles.removeAll { $0.title == article.headline.main }
        completion(.success(()))
    }

    override func isAlreadySaved(_ news: New) -> Bool {
        return savedArticles.contains { $0.title == news.title }
    }

    override func isAlreadySaved(_ doc: Doc) -> Bool {
        return savedArticles.contains { $0.title == doc.headline.main }
    }
}
