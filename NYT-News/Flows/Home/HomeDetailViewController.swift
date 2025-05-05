//
//  HomeDetailViewController.swift
//  NYT-News
//
//  Created by Beyza Nur Tekerek on 11.04.2025.
//

import UIKit
import SDWebImage

class HomeDetailViewController: UIViewController {

    var news: New?

    private let customNavBar: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let navSaveButton: UIButton = {
        let button = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 25)
        let image = UIImage(systemName: "bookmark", withConfiguration: config)
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let navBackButton: UIButton = {
        let button = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 30)
        button.setImage(UIImage(systemName: "chevron.left", withConfiguration: config), for: .normal)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let navBackButtonContainer: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .light)
        let view = UIVisualEffectView(effect: blurEffect)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.layer.cornerRadius = 25
        return view
    }()

    private let navSaveButtonContainer: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .light)
        let view = UIVisualEffectView(effect: blurEffect)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.layer.cornerRadius = 25
        return view
    }()
    
    private let infoContainerView: UIView = {
       let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let detailImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let sectionLabel: PaddingLabel = {
        let label = PaddingLabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = .white
        label.layer.cornerRadius = 5
        label.layer.masksToBounds = true
        label.backgroundColor = .systemCyan
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.numberOfLines = 2
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let bylineLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15)
        label.numberOfLines = 2
        label.textColor = .lightGray
        return label
    }()
    
    private let abstractLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17)
        label.numberOfLines = 6
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let readMoreButton: UIButton = {
        let button = UIButton()
        button.setTitle("Read More", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemCyan
        button.layer.cornerRadius = 20
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        view.addSubview(detailImageView)
        view.addSubview(infoContainerView)
        view.addSubview(sectionLabel)
        view.addSubview(customNavBar)
        
        customNavBar.addSubview(navBackButtonContainer)
        customNavBar.addSubview(navSaveButtonContainer)

        navBackButtonContainer.contentView.addSubview(navBackButton)
        navSaveButtonContainer.contentView.addSubview(navSaveButton)
        
        infoContainerView.addSubview(titleLabel)
        infoContainerView.addSubview(bylineLabel)
        infoContainerView.addSubview(abstractLabel)
        infoContainerView.addSubview(readMoreButton)
        
        applyConstraints()
        setupReadMoreButton()
        setupNavBar()

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        tabBarController?.tabBar.isHidden = false
    }
    
    @objc private func didTapBack() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func didTapSave() {
        
        guard let article = news else { return }
        let config = UIImage.SymbolConfiguration(pointSize: 25)
        let isSaved = DataPersistenceManager.shared.isAlreadySaved(article)
        
        if isSaved {
            DataPersistenceManager.shared.deleteArticle(from: article) { result in
                switch result {
                case .success():
                    print("Successfully deleted.")
                    self.view.showToast(message: "UNSAVED 🙁")
                case .failure(let error):
                    print("Delete failed: \(error.localizedDescription)")
                }
            }
            let image = UIImage(systemName: "bookmark", withConfiguration: config)
            navSaveButton.setImage(image, for: .normal)
        } else {
            DataPersistenceManager.shared.saveArticle(from: article) { result in
                switch result {
                case .success():
                    print("Successfully saved.")
                    self.view.showToast(message: "SAVED 🙂")
                case .failure(let error):
                    print("Save failed: \(error.localizedDescription)")
                }
            }
            let filledImage = UIImage(systemName: "bookmark.fill", withConfiguration: config)
            navSaveButton.setImage(filledImage, for: .normal)
        }
        NotificationCenter.default.post(name: .didChangeSavedStatus, object: nil)
    }
    
    private func setupNavBar() {
        navSaveButton.addTarget(self, action: #selector(didTapSave), for: .touchUpInside)
        navBackButton.addTarget(self, action: #selector(didTapBack), for: .touchUpInside)
    }
    
    private func setupReadMoreButton() {
        readMoreButton.addTarget(self, action: #selector(readMoreButtonClicked), for: .touchUpInside)
    }
    

    @objc private func readMoreButtonClicked() {
        guard let urlString = news?.url,
              let url = URL(string: urlString) else { return }
        UIApplication.shared.open(url)
    }
    
    
    private func applyConstraints() {
        let customNavBarConstraints = [
            customNavBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            customNavBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            customNavBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            customNavBar.heightAnchor.constraint(equalToConstant: 40)
        ]
        let navSaveButtonConstraints = [
            navSaveButton.centerXAnchor.constraint(equalTo: navSaveButtonContainer.contentView.centerXAnchor),
            navSaveButton.centerYAnchor.constraint(equalTo: navSaveButtonContainer.contentView.centerYAnchor)
        ]
        let navBackButtonConstraints = [
            navBackButton.centerXAnchor.constraint(equalTo: navBackButtonContainer.contentView.centerXAnchor),
            navBackButton.centerYAnchor.constraint(equalTo: navBackButtonContainer.contentView.centerYAnchor)
        ]
        let navBackButtonContainerConstraints = [
            navBackButtonContainer.leadingAnchor.constraint(equalTo: customNavBar.leadingAnchor, constant: 20),
            navBackButtonContainer.centerYAnchor.constraint(equalTo: customNavBar.centerYAnchor),
            navBackButtonContainer.widthAnchor.constraint(equalToConstant: 50),
            navBackButtonContainer.heightAnchor.constraint(equalToConstant: 50)
        ]
        let navSaveButtonContainerConstraints = [
            navSaveButtonContainer.trailingAnchor.constraint(equalTo: customNavBar.trailingAnchor, constant: -20),
            navSaveButtonContainer.centerYAnchor.constraint(equalTo: customNavBar.centerYAnchor),
            navSaveButtonContainer.widthAnchor.constraint(equalToConstant: 50),
            navSaveButtonContainer.heightAnchor.constraint(equalToConstant: 50)
        ]
        let infoContainerViewConstraints = [
            infoContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            infoContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            infoContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            infoContainerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.32)
        ]
        let detailImageViewConstraints = [
            detailImageView.topAnchor.constraint(equalTo: view.topAnchor),
            detailImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            detailImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            detailImageView.bottomAnchor.constraint(equalTo: infoContainerView.topAnchor, constant: 20)
        ]
        let sectionLabelConstraints = [
            sectionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            sectionLabel.bottomAnchor.constraint(equalTo: infoContainerView.topAnchor, constant: -16)
        ]
        let titleLabelConstraints = [
            titleLabel.topAnchor.constraint(equalTo: infoContainerView.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: infoContainerView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: infoContainerView.trailingAnchor, constant: -16)
        ]
        let bylineLabelConstraints = [
            bylineLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            bylineLabel.leadingAnchor.constraint(equalTo: infoContainerView.leadingAnchor, constant: 16),
            bylineLabel.trailingAnchor.constraint(equalTo: infoContainerView.trailingAnchor, constant: -16)
        ]
        let abstractLabelConstraints = [
            abstractLabel.topAnchor.constraint(equalTo: bylineLabel.bottomAnchor, constant: 10),
            abstractLabel.leadingAnchor.constraint(equalTo: infoContainerView.leadingAnchor, constant: 16),
            abstractLabel.trailingAnchor.constraint(equalTo: infoContainerView.trailingAnchor, constant: -16)
        ]
        let readMoreButtonConstraints = [
            readMoreButton.leadingAnchor.constraint(equalTo: infoContainerView.leadingAnchor, constant: 16),
            readMoreButton.trailingAnchor.constraint(equalTo: infoContainerView.trailingAnchor, constant: -16),
            readMoreButton.heightAnchor.constraint(equalToConstant: 42),
            readMoreButton.bottomAnchor.constraint(equalTo: infoContainerView.bottomAnchor, constant: -50)
        ]
        
        NSLayoutConstraint.activate(customNavBarConstraints)
        NSLayoutConstraint.activate(navSaveButtonConstraints)
        NSLayoutConstraint.activate(navBackButtonConstraints)
        NSLayoutConstraint.activate(navSaveButtonContainerConstraints)
        NSLayoutConstraint.activate(navBackButtonContainerConstraints)
        NSLayoutConstraint.activate(infoContainerViewConstraints)
        NSLayoutConstraint.activate(detailImageViewConstraints)
        NSLayoutConstraint.activate(sectionLabelConstraints)
        NSLayoutConstraint.activate(titleLabelConstraints)
        NSLayoutConstraint.activate(bylineLabelConstraints)
        NSLayoutConstraint.activate(abstractLabelConstraints)
        NSLayoutConstraint.activate(readMoreButtonConstraints)
        
    }
    
    
    public func configureWithNews(with model: New) {
        self.news = model
        guard let urlString = model.multimedia?.first?.url,
              let url = URL(string: urlString) else { return }
        
        detailImageView.sd_setImage(with: url)
        sectionLabel.text = model.section?.uppercased()
        titleLabel.text = model.title
        abstractLabel.text = model.abstract
        bylineLabel.text = "• \(model.byline ?? "Unknown Author")"
        
        let config = UIImage.SymbolConfiguration(pointSize: 25)
        if let news = self.news, DataPersistenceManager.shared.isAlreadySaved(news) {
            navSaveButton.setImage(UIImage(systemName: "bookmark.fill", withConfiguration: config), for: .normal)
        } else {
            navSaveButton.setImage(UIImage(systemName: "bookmark", withConfiguration: config), for: .normal)
        }
    }
    
    
    
}
