//
//  DetailVC.swift
//  NYT-News
//
//  Created by Beyza Nur Tekerek on 11.04.2025.
//

import UIKit
import SDWebImage

class DetailVC: UIViewController {

    var news: New?

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
        label.backgroundColor = .systemMint
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
        button.backgroundColor = .systemMint
        button.layer.cornerRadius = 12
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let saveButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "bookmark", withConfiguration: UIImage.SymbolConfiguration(pointSize: 25))
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        self.tabBarController?.tabBar.isHidden = true
        
        view.addSubview(detailImageView)
        view.addSubview(infoContainerView)
        view.addSubview(sectionLabel)
        view.addSubview(saveButton)
        
        infoContainerView.addSubview(titleLabel)
        infoContainerView.addSubview(bylineLabel)
        infoContainerView.addSubview(abstractLabel)
        infoContainerView.addSubview(readMoreButton)
        
        applyConstraints()
        setupReadMoreButton()
        setupSaveButton()
    }

    private func setupReadMoreButton() {
        readMoreButton.addTarget(self, action: #selector(readMoreButtonClicked), for: .touchUpInside)
    }
    
    private func setupSaveButton() {
        saveButton.addTarget(self, action: #selector(saveButtonClicked), for: .touchUpInside)
    }
    
    @objc private func readMoreButtonClicked() {
        guard let urlString = news?.url,
              let url = URL(string: urlString) else { return }
        UIApplication.shared.open(url)
    }
    
    @objc private func saveButtonClicked() {
        // İSLEMLER
        
        saveButton.isSelected.toggle()
        
        if saveButton.isSelected {
            let filledImage = UIImage(systemName: "bookmark.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 25))?
                .withRenderingMode(.alwaysOriginal)
            saveButton.tintColor = .white
            saveButton.setImage(filledImage, for: .normal)
        } else {
            let emptyImage = UIImage(systemName: "bookmark", withConfiguration: UIImage.SymbolConfiguration(pointSize: 25))?
                .withRenderingMode(.alwaysOriginal)
            saveButton.tintColor = .white
            saveButton.setImage(emptyImage, for: .normal)
        }
    }
    
    private func applyConstraints() {
        let saveButtonconstraints = [
            saveButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 70),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            saveButton.widthAnchor.constraint(equalToConstant: 60),
            saveButton.heightAnchor.constraint(equalToConstant: 60)
        ]
        let infoContainerViewConstraints = [
            infoContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            infoContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            infoContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            infoContainerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.31)
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
            readMoreButton.heightAnchor.constraint(equalToConstant: 40),
            readMoreButton.bottomAnchor.constraint(equalTo: infoContainerView.bottomAnchor, constant: -50)
        ]
        
        NSLayoutConstraint.activate(saveButtonconstraints)
        NSLayoutConstraint.activate(infoContainerViewConstraints)
        NSLayoutConstraint.activate(detailImageViewConstraints)
        NSLayoutConstraint.activate(sectionLabelConstraints)
        NSLayoutConstraint.activate(titleLabelConstraints)
        NSLayoutConstraint.activate(bylineLabelConstraints)
        NSLayoutConstraint.activate(abstractLabelConstraints)
        NSLayoutConstraint.activate(readMoreButtonConstraints)
        
    }
    
    
    public func configure(with model: New) {
        self.news = model
        guard let urlString = model.multimedia?.first?.url,
              let url = URL(string: urlString) else { return }
        
        detailImageView.sd_setImage(with: url)
        sectionLabel.text = model.section?.uppercased()
        titleLabel.text = model.title
        abstractLabel.text = model.abstract
        bylineLabel.text = "• \(model.byline ?? "Unknown Author")"
    }
    
    
    
}

//    .symbolEffect(.bounce)
