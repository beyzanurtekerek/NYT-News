//
//  RecommendationTableViewCell.swift
//  NYT-News
//
//  Created by Beyza Nur Tekerek on 9.04.2025.
//

import UIKit
import SDWebImage

class RecommendationTableViewCell: UITableViewCell {

    static let identifier = "RecommendationTableViewCell"
    
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 8
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.3).cgColor
        view.layer.masksToBounds = true
        return view
    }()
    
    private let populerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 4
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let bylineLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .lightGray
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .lightGray
        return label
    }()

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(containerView)
        containerView.addSubview(populerImageView)
        containerView.addSubview(bylineLabel)
        containerView.addSubview(titleLabel)
        containerView.addSubview(dateLabel)
        
        applyConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func applyConstraints() {
        let containerConstraints = [
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ]
        let populerImageViewConstraints = [
            populerImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            populerImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            populerImageView.widthAnchor.constraint(equalToConstant: 100),
            populerImageView.heightAnchor.constraint(equalToConstant: 100)
        ]
        let bylineLabelConstraints = [
            bylineLabel.bottomAnchor.constraint(equalTo: titleLabel.topAnchor, constant: -10),
            bylineLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            bylineLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor)
        ]
        let titleLabelConstraints = [
            titleLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: populerImageView.trailingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16)
        ]
        let dateLabelConstraints = [
            dateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            dateLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            dateLabel.bottomAnchor.constraint(lessThanOrEqualTo: containerView.bottomAnchor, constant: -10)
        ]
        
        NSLayoutConstraint.activate(containerConstraints)
        NSLayoutConstraint.activate(populerImageViewConstraints)
        NSLayoutConstraint.activate(titleLabelConstraints)
        NSLayoutConstraint.activate(bylineLabelConstraints)
        NSLayoutConstraint.activate(dateLabelConstraints)
    }
    
    public func configure(with model: New) {
        guard let urlString = model.multimedia?.first?.url,
              let url = URL(string: urlString) else { return }
        
        titleLabel.text = model.title
        bylineLabel.text = "• \(model.byline ?? "Unknown Author")"
        dateLabel.text = DateFormatterUtil.formattedDate(from: model.published_date ?? "")
        populerImageView.sd_setImage(with: url)
    }
    
}
