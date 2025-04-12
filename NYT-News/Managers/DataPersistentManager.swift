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
    
    func saveNewWith(model: New, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let context = appDelegate.persistentContainer.viewContext
        let item = NewsItem(context: context)
        
        item.title = model.title
        item.abstract = model.abstract
        item.url = model.url
        item.byline = model.byline
        item.published_date = model.published_date
        item.section = model.section
        item.imageUrl = model.multimedia?.first?.url ?? ""
        
        do {
            try context.save()
            completion(.success(()))
        } catch {
            completion(.failure(DatabaseError.failedToSaveData))
        }
    }
    
    func fetchFromDataBase(completion: @escaping (Result<[NewsItem], Error>) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let context = appDelegate.persistentContainer.viewContext
        let request: NSFetchRequest<NewsItem> = NewsItem.fetchRequest()
        
        do {
            let newsItems = try context.fetch(request)
            completion(.success(newsItems))
        } catch {
            completion(.failure(DatabaseError.failedToFetchData))
        }
    }
    
    func deleteNewWith(model: NewsItem, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let context = appDelegate.persistentContainer.viewContext
        context.delete(model)
        
        do {
            try context.save()
            completion(.success(()))
        } catch {
            completion(.failure(DatabaseError.failedToDeleteData))
        }
    }
    
    
}
