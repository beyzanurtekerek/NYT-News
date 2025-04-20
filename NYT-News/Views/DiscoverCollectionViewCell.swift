//
//  SearchCollectionViewCell.swift
//  NYT-News
//
//  Created by Beyza Nur Tekerek on 14.04.2025.
//

import UIKit

class DiscoverCollectionViewCell: UICollectionViewCell {

    static let identifier = "DiscoverCollectionViewCell"
    var news: New?
    var docs: Doc?

    // NESNELER EKLENECEK - DÜZENLENECEK!!!
    
    private let searchImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        imageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let abstractlabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 11, weight: .regular)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let sectionLabel: PaddingLabel = {
        let label = PaddingLabel()
        label.font = .systemFont(ofSize: 11, weight: .bold)
        label.textColor = .white
        label.layer.cornerRadius = 3
        label.layer.masksToBounds = true
        label.backgroundColor = UIColor.red.withAlphaComponent(0.6)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let headlineLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .medium)
        label.textColor = .white
        label.numberOfLines = 2
        label.shadowColor = UIColor.black.withAlphaComponent(0.3)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let bylineLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 11, weight: .regular)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let readMoreButton: UIButton = {
        let button = UIButton()
        button.setTitle("Read More", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemCyan
        button.layer.cornerRadius = 16
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func prepareForReuse() {
        super.prepareForReuse()
        
        searchImageView.image = nil
        headlineLabel.text = nil
        abstractlabel.text = nil
        dateLabel.text = nil
        sectionLabel.text = nil
        bylineLabel.text = nil
        
        docs = nil
        news = nil
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(searchImageView)
        contentView.addSubview(abstractlabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(sectionLabel)
        contentView.addSubview(headlineLabel)
        contentView.addSubview(bylineLabel)
        contentView.addSubview(readMoreButton)
        
        applyConstraints()
        readMoreButton.addTarget(self, action: #selector(readMoreButtonClicked), for: .touchUpInside)
        
        contentView.layer.cornerRadius = 12
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.systemGray4.cgColor
        contentView.layer.masksToBounds = true
        
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    @objc private func readMoreButtonClicked() {
        if let urlString = docs?.web_url, let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        } else if let urlString = news?.url, let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
    
    private func applyConstraints() {
        let searchImageViewConstraints = [
            searchImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            searchImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            searchImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            searchImageView.bottomAnchor.constraint(equalTo: dateLabel.topAnchor, constant: -8)
        ]
        let sectionLabelConstraints = [
            sectionLabel.leadingAnchor.constraint(equalTo: searchImageView.leadingAnchor, constant: 8),
            sectionLabel.trailingAnchor.constraint(equalTo: sectionLabel.trailingAnchor, constant: -8),
            sectionLabel.bottomAnchor.constraint(equalTo: headlineLabel.topAnchor, constant: -4)
        ]
        let headlineLabelConstraints = [
            headlineLabel.bottomAnchor.constraint(equalTo: searchImageView.bottomAnchor, constant: -8),
            headlineLabel.leadingAnchor.constraint(equalTo: searchImageView.leadingAnchor, constant: 8),
            headlineLabel.trailingAnchor.constraint(equalTo: searchImageView.trailingAnchor, constant: -8)
        ]
        let dateLabelConstraints = [
            dateLabel.bottomAnchor.constraint(equalTo: bylineLabel.topAnchor, constant: -8),
            dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8)
        ]
        let bylineLabelConstraints = [
            bylineLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            bylineLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            bylineLabel.bottomAnchor.constraint(equalTo: abstractlabel.topAnchor, constant: -8)
        ]
        let abstractlabelConstraints = [
            abstractlabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            abstractlabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            abstractlabel.bottomAnchor.constraint(equalTo: readMoreButton.topAnchor, constant: -8)
        ]
        let readMoreButtonConstraints = [
            readMoreButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            readMoreButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            readMoreButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ]
            
        NSLayoutConstraint.activate(searchImageViewConstraints)
        NSLayoutConstraint.activate(headlineLabelConstraints)
        NSLayoutConstraint.activate(abstractlabelConstraints)
        NSLayoutConstraint.activate(dateLabelConstraints)
        NSLayoutConstraint.activate(sectionLabelConstraints)
        NSLayoutConstraint.activate(bylineLabelConstraints)
        NSLayoutConstraint.activate(readMoreButtonConstraints)
    }
    
    public func configure(with model: Doc) {
        self.docs = model
        headlineLabel.text = model.headline.main
        abstractlabel.text = model.abstract
        dateLabel.text = DateFormatterUtil.formattedDate(from: model.pub_date ?? "")
        sectionLabel.text = model.section_name?.uppercased()
        
        if let imageUrlString = model.multimedia.multimediaDefault?.url,
           let imageUrl = URL(string: imageUrlString) {
            URLSession.shared.dataTask(with: imageUrl) { data, _, _ in
                if let data = data {
                    DispatchQueue.main.async {
                        self.searchImageView.image = UIImage(data: data)
                    }
                }
            }
            .resume()
        } else {
            searchImageView.image = UIImage(named: "placeholder")
        }
    }
    
    public func configure(with model: New) {
        self.news = model
        headlineLabel.text = model.title
        abstractlabel.text = model.abstract
        dateLabel.text = DateFormatterUtil.formattedDate(from: model.published_date ?? "")
        sectionLabel.text = model.section?.uppercased()
        bylineLabel.text = "• \(model.byline ?? "Unknown Author")"
        
        if let imageUrlString = model.multimedia?.first?.url,
           let imageUrl = URL(string: imageUrlString) {
            URLSession.shared.dataTask(with: imageUrl) { data, _, _ in
                if let data = data {
                    DispatchQueue.main.async {
                        self.searchImageView.image = UIImage(data: data)
                    }
                }
            }.resume()
        } else {
            searchImageView.image = UIImage(named: "placeholder")
        }
    }
    
}



