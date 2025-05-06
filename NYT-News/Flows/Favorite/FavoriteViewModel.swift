//
//  FavoriteViewModel.swift
//  NYT-News
//
//  Created by Beyza Nur Tekerek on 6.05.2025.
//

import Foundation
import CoreData
import UIKit

protocol FavoriteViewModelDelegate: AnyObject {
    func didUpdateArticles()
    func showToast(message: String)
}

class FavoriteViewModel {
    // MARK: - Properties
    private(set) var savedArticles: [SavedArticle] = []
    weak var delegate: FavoriteViewModelDelegate?

    // MARK: - Data Fetching
    func fetchSavedArticles() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let request: NSFetchRequest<SavedArticle> = SavedArticle.fetchRequest()
        
        do {
            savedArticles = try context.fetch(request)
            DispatchQueue.main.async {
                self.delegate?.didUpdateArticles()
            }
        } catch {
            print("Failed to fetch saved articles: \(error.localizedDescription)")
        }
    }

    // MARK: - Article Conversion
    func articleAsNew(at index: Int) -> New {
        let article = savedArticles[index]
        let multimedia = article.imageUrl != nil ? [Multimedia(url: article.imageUrl!)] : nil
        return New(
            section: article.section ?? "",
            title: article.title ?? "",
            abstract: article.abstractText ?? "",
            url: article.url ?? "",
            byline: article.byline ?? "",
            published_date: article.publishedDate,
            multimedia: multimedia
        )
    }
    
    // MARK: - Save/Unsaving Logic
    func toggleSaveStatus(for article: SavedArticle, indexPath: IndexPath) {
        guard let source = article.source else { return }

        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<SavedArticle> = SavedArticle.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "url == %@", article.url ?? "")

        do {
            let existing = try context.fetch(fetchRequest)

            if existing.isEmpty {
                saveArticle(article, source: source)
            } else {
                deleteArticle(article, source: source, indexPath: indexPath)
            }
        } catch {
            print("Fetch failed: \(error.localizedDescription)")
        }
    }

    private func saveArticle(_ article: SavedArticle, source: String) {
        switch source {
        case "New":
            let newModel = New(
                section: article.section ?? "",
                title: article.title ?? "",
                abstract: article.abstractText ?? "",
                url: article.url ?? "",
                byline: article.byline ?? "",
                published_date: article.publishedDate,
                multimedia: article.imageUrl != nil ? [Multimedia(url: article.imageUrl!)] : nil
            )
            DataPersistenceManager.shared.saveArticle(from: newModel) { [weak self] result in
                self?.handleSaveResult(result)
            }

        case "Doc":
            let docModel = Doc(
                abstract: article.abstractText,
                byline: Byline(original: article.byline),
                multimedia: SearchMultimedia(multimediaDefault: Default(url: article.imageUrl)),
                pub_date: article.publishedDate,
                headline: Headline(main: article.title),
                section_name: article.section,
                web_url: article.url
            )
            DataPersistenceManager.shared.saveArticle(from: docModel) { [weak self] result in
                self?.handleSaveResult(result)
            }

        default:
            print("Unknown article type.")
        }
    }

    private func deleteArticle(_ article: SavedArticle, source: String, indexPath: IndexPath) {
        switch source {
        case "New":
            let newModel = New(
                section: article.section ?? "",
                title: article.title ?? "",
                abstract: article.abstractText ?? "",
                url: article.url ?? "",
                byline: article.byline ?? "",
                published_date: article.publishedDate,
                multimedia: article.imageUrl != nil ? [Multimedia(url: article.imageUrl!)] : nil
            )
            DataPersistenceManager.shared.deleteArticle(from: newModel) { [weak self] result in
                self?.handleDeleteResult(result, indexPath: indexPath)
            }

        case "Doc":
            let docModel = Doc(
                abstract: article.abstractText,
                byline: Byline(original: article.byline),
                multimedia: SearchMultimedia(multimediaDefault: Default(url: article.imageUrl)),
                pub_date: article.publishedDate,
                headline: Headline(main: article.title),
                section_name: article.section,
                web_url: article.url
            )
            DataPersistenceManager.shared.deleteArticle(from: docModel) { [weak self] result in
                self?.handleDeleteResult(result, indexPath: indexPath)
            }

        default:
            print("Unknown article type.")
        }
    }

    private func handleSaveResult(_ result: Result<Void, Error>) {
        switch result {
        case .success():
            print("Saved successfully.")
            DispatchQueue.main.async {
                self.delegate?.showToast(message: "Saved successfully")
            }
            fetchSavedArticles()
        case .failure(let error):
            print("Error saving: \(error.localizedDescription)")
            DispatchQueue.main.async {
                self.delegate?.showToast(message: "Failed to save article.")
            }
        }
    }

    private func handleDeleteResult(_ result: Result<Void, Error>, indexPath: IndexPath) {
        switch result {
        case .success():
            print("Deleted from saved.")
            savedArticles.remove(at: indexPath.item)
            DispatchQueue.main.async {
                self.delegate?.didUpdateArticles()
                self.delegate?.showToast(message: "Unsaved successfully")
            }
        case .failure(let error):
            print("Error deleting: \(error.localizedDescription)")
        }
    }
}
