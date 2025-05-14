//
//  DataPersistentManager.swift
//  NYT-News
//
//  Created by Beyza Nur Tekerek on 12.04.2025.
//

import Foundation
import UIKit
import CoreData

class DataPersistenceManager {
    
    enum DatabaseError: Error {
        case failedToSaveData
        case failedToFetchData
        case failedToDeleteData
    }
    
    static let shared = DataPersistenceManager()
    
    var persistentContainer: NSPersistentContainer {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer
    }
    
    private func saveArticle(configure: (SavedArticle) -> Void, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        let item = SavedArticle(context: context)
        configure(item)
        do {
            try context.save()
            completion(.success(()))
        } catch {
            completion(.failure(DatabaseError.failedToSaveData))
        }
    }
    
    func saveArticle(from new: New, completion: @escaping (Result<Void, Error>) -> Void) {
        saveArticle(configure: { item in
            item.title = new.title ?? ""
            item.abstractText = new.abstract ?? ""
            item.url = new.url ?? ""
            item.imageUrl = new.multimedia?.first?.url ?? ""
            item.publishedDate = new.published_date
            item.section = new.section ?? ""
            item.byline = new.byline ?? ""
            item.source = "new"
        }, completion: completion)
    }
    
    func saveArticle(from doc: Doc, completion: @escaping (Result<Void, Error>) -> Void) {
        saveArticle(configure: { item in
            item.title = doc.headline.main ?? ""
            item.abstractText = doc.abstract ?? ""
            item.url = doc.web_url ?? ""
            item.imageUrl = doc.multimedia.multimediaDefault?.url ?? ""
            item.publishedDate = doc.pub_date
            item.section = doc.section_name ?? ""
            item.byline = doc.byline.original ?? ""
            item.source = "doc"
        }, completion: completion)
    }
    
    func fetchSavedArticles(completion: @escaping (Result<[SavedArticle], Error>) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        let request: NSFetchRequest<SavedArticle> = SavedArticle.fetchRequest()
        
        do {
            let savedArticles = try context.fetch(request)
            completion(.success(savedArticles))
        } catch {
            completion(.failure(DatabaseError.failedToFetchData))
        }
    }
    
    private func performDeletion(predicate: NSPredicate, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<SavedArticle> = SavedArticle.fetchRequest()
        fetchRequest.predicate = predicate
        do {
            let results = try context.fetch(fetchRequest)
            results.forEach { context.delete($0) }
            try context.save()
            completion(.success(()))
        } catch {
            completion(.failure(error))
        }
    }
    
    func deleteArticle(from article: New, completion: @escaping (Result<Void, Error>) -> Void) {
        let predicate = NSPredicate(format: "title == %@", article.title ?? "")
        performDeletion(predicate: predicate, completion: completion)
    }
    
    func deleteArticle(from article: Doc, completion: @escaping (Result<Void, Error>) -> Void) {
        let predicate = NSPredicate(format: "title == %@", article.headline.main ?? "")
        performDeletion(predicate: predicate, completion: completion)
    }
    
    private func isSaved(predicate: NSPredicate) -> Bool {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return false }
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<SavedArticle> = SavedArticle.fetchRequest()
        fetchRequest.predicate = predicate
        do {
            return try context.count(for: fetchRequest) > 0
        } catch {
            return false
        }
    }
    
    func isAlreadySaved(_ news: New) -> Bool {
        let predicate = NSPredicate(format: "title == %@", news.title ?? "")
        return isSaved(predicate: predicate)
    }
    
    func isAlreadySaved(_ doc: Doc) -> Bool {
        let predicate = NSPredicate(format: "title == %@", doc.headline.main ?? "")
        return isSaved(predicate: predicate)
    }
    
    func delete(_ news: New) {
        deleteArticle(from: news) { _ in }
    }
    
    func delete(_ doc: Doc) {
        deleteArticle(from: doc) { _ in }
    }
}
