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
    
//    func saveNewWith(model: New, completion: @escaping (Result<Void, Error>) -> Void) {
//        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
//        
//        let context = appDelegate.persistentContainer.viewContext
//        let item = NewsItem(context: context)
//        
//        item.title = model.title
//        item.abstract = model.abstract
//        item.url = model.url
//        item.byline = model.byline
//        item.published_date = model.published_date
//        item.section = model.section
//        item.imageUrl = model.multimedia?.first?.url ?? ""
//        
//        do {
//            try context.save()
//            completion(.success(()))
//        } catch {
//            completion(.failure(DatabaseError.failedToSaveData))
//        }
//    }
//    
//    func fetchFromDataBase(completion: @escaping (Result<[NewsItem], Error>) -> Void) {
//        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
//        
//        let context = appDelegate.persistentContainer.viewContext
//        let request: NSFetchRequest<NewsItem> = NewsItem.fetchRequest()
//        
//        do {
//            let newsItems = try context.fetch(request)
//            completion(.success(newsItems))
//        } catch {
//            completion(.failure(DatabaseError.failedToFetchData))
//        }
//    }
//    
//    func deleteNewWith(model: NewsItem, completion: @escaping (Result<Void, Error>) -> Void) {
//        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
//        
//        let context = appDelegate.persistentContainer.viewContext
//        context.delete(model)
//        
//        do {
//            try context.save()
//            completion(.success(()))
//        } catch {
//            completion(.failure(DatabaseError.failedToDeleteData))
//        }
//    }
    
    func saveArticle(from new: New, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        let item = SavedArticle(context: context)
        item.title = new.title
        item.abstractText = new.abstract
        item.url = new.url
        item.imageUrl = new.multimedia?.first?.url ?? ""
        item.publishedDate = new.published_date
        item.section = new.section
        item.byline = new.byline
        item.source = "new"
        do {
            try context.save()
            completion(.success(()))
        } catch {
            completion(.failure(DatabaseError.failedToSaveData))
        }
    }

    func saveArticle(from doc: Doc, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        let item = SavedArticle(context: context)
        item.title = doc.headline.main
        item.abstractText = doc.abstract
        item.url = doc.web_url
        item.imageUrl = doc.multimedia.multimediaDefault?.url ?? ""
        item.publishedDate = doc.pub_date
        item.section = doc.section_name
        item.byline = doc.byline.original
        item.source = "doc"
        do {
            try context.save()
            completion(.success(()))
        } catch {
            completion(.failure(DatabaseError.failedToSaveData))
        }
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

    func deleteArticle(_ article: SavedArticle, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        context.delete(article)
        
        do {
            try context.save()
            completion(.success(()))
        } catch {
            completion(.failure(DatabaseError.failedToDeleteData))
        }
    }
    
}
