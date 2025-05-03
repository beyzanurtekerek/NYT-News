//
//  SavedVC.swift
//  NYT-News
//
//  Created by Beyza Nur Tekerek on 9.04.2025.
//

import UIKit
import CoreData

class SavedVC: UIViewController {

    private var savedArticles: [SavedArticle] = []
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Saved Articles"
        label.font = UIFont.boldSystemFont(ofSize: 26)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 20
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(DiscoverCollectionViewCell.self, forCellWithReuseIdentifier: DiscoverCollectionViewCell.identifier)
        return collectionView
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        NotificationCenter.default.addObserver(self, selector: #selector(refreshData), name: .didChangeSavedStatus, object: nil)
        
        view.addSubview(titleLabel)
        view.addSubview(collectionView)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        configureNavbar()
        applyConstraints()
        fetchSavedArticles()
        updateUI()
    }
    
    @objc func refreshData() {
        fetchSavedArticles()
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let padding: CGFloat = 16
        
        collectionView.frame = CGRect(
            x: 0,
            y: titleLabel.frame.maxY + padding,
            width: view.frame.width,
            height: view.frame.height - titleLabel.frame.maxY - padding
        )
    }
    
    private func applyConstraints() {
        let titleLabelConstraints = [
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        ]
        
        NSLayoutConstraint.activate(titleLabelConstraints)
    }
    
    func updateUI() {
        self.collectionView.reloadData()
    }
    
    private func fetchSavedArticles() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let request: NSFetchRequest<SavedArticle> = SavedArticle.fetchRequest()
        
        do {
            savedArticles = try context.fetch(request)
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        } catch {
            print("Failed to fetch saved articles: \(error.localizedDescription)")
        }
    }
    
}

extension SavedVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return savedArticles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DiscoverCollectionViewCell.identifier, for: indexPath) as? DiscoverCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let article = savedArticles[indexPath.row]
        
        let multimedia: [Multimedia]? = {
            if let imageUrl = article.imageUrl {
                return [Multimedia(url: imageUrl)]
            } else {
                return nil
            }
        }()
        
        let newModel = New(
            section: article.section ?? "",
            title: article.title ?? "",
            abstract: article.abstractText ?? "",
            url: article.url ?? "",
            byline: article.byline ?? "",
            published_date: article.publishedDate,
            multimedia: multimedia
        )
        
        cell.configure(with: newModel)
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width - 32
        return CGSize(width: width, height: 350)
    }
}

extension SavedVC: DiscoverCollectionViewCellDelegate {
    func didTapSaveButton(on cell: DiscoverCollectionViewCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        let article = savedArticles[indexPath.item]
        guard let source = article.source else { return }

        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<SavedArticle> = SavedArticle.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "url == %@", article.url ?? "")

        do {
            let existing = try context.fetch(fetchRequest)

            if existing.isEmpty {
                
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
                    DataPersistenceManager.shared.saveArticle(from: newModel) { result in
                        self.handleSaveResult(result)
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
                    DataPersistenceManager.shared.saveArticle(from: docModel) { result in
                        self.handleSaveResult(result)
                    }

                default:
                    print("Unknown article type.")
                }

            } else {
                
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
                    DataPersistenceManager.shared.deleteArticle(from: newModel) { result in
                        self.handleDeleteResult(result, indexPath: indexPath)
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
                    DataPersistenceManager.shared.deleteArticle(from: docModel) { result in
                        self.handleDeleteResult(result, indexPath: indexPath)
                    }

                default:
                    print("Unknown article type.")
                }
            }
        } catch {
            print("Fetch failed: \(error.localizedDescription)")
        }
    }

    private func handleDeleteResult(_ result: Result<Void, Error>, indexPath: IndexPath) {
        switch result {
        case .success():
            print("Deleted from saved.")
            savedArticles.remove(at: indexPath.item)
            DispatchQueue.main.async {
                self.collectionView.deleteItems(at: [indexPath])
                self.view.showToast(message: "Unsaved successfully")
            }
        case .failure(let error):
            print("Error deleting: \(error.localizedDescription)")
        }
    }
    
    private func handleSaveResult(_ result: Result<Void, Error>) {
        switch result {
        case .success():
            print("Saved successfully.")
            DispatchQueue.main.async {
                self.view.showToast(message: "Saved successfully")
            }
            fetchSavedArticles()
        case .failure(let error):
            print("Error saving: \(error.localizedDescription)")
            DispatchQueue.main.async {
                self.view.showToast(message: "Failed to save article.")
            }

        }
    }
}
