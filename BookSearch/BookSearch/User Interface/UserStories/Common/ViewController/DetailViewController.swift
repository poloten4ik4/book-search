//
//  DetailViewController.swift
//  BookSearch
//
//  Created by Zaslavskiy Mike on 18/12/2019.
//  Copyright © 2019 MikeZaslavskiy. All rights reserved.
//

import UIKit
import Kingfisher

class BookDetailViewController: UIViewController {
    var viewModel: BookDetailViewModel?
    
    // MARK: - UI elements
    
    private let imageView = UIImageView()
    private let labelsStackView = UIStackView()
    private let authorLabel = UILabel()
    private let titleLabel = UILabel()
    private let firstPublishYearLabel = UILabel()
    
    
    // MARK: - Constants related to View Controller
    
    private enum Constants {
        static let standardSpacing: CGFloat = 10.0
    }
    
    // MARK: - Lyfecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    // MARK: - Layout
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        layoutViews()
    }
    
    private func layoutViews() {
        // Our viewController's view has valid size and we can do the layout
        layoutImageView()
        layoutStackView()
    }
    
    private func layoutImageView() {
        let origin = CGPoint(x: 0, y: topbarHeight)
        // Let's assume it's a square image view
        let size = CGSize(width: view.bounds.width, height: view.bounds.width)
        imageView.frame = CGRect(origin: origin, size: size)
    }
    
    private func layoutStackView() {
        let stackViewY = topbarHeight + view.bounds.width + Constants.standardSpacing
        let stackViewWidth = view.bounds.width - 2 * Constants.standardSpacing
        let stackViewHeight = Constants.standardSpacing * 2 + titleLabel.intrinsicContentSize.height + firstPublishYearLabel.intrinsicContentSize.height + authorLabel.intrinsicContentSize.height
        
        let origin = CGPoint(x: Constants.standardSpacing, y: stackViewY)
        let size = CGSize(width: stackViewWidth, height: stackViewHeight)
        
        labelsStackView.frame = CGRect(origin: origin, size: size)
    }
    
    // MARK: - Configuration
    
    private func configureView() {
        guard let viewModel = self.viewModel else { return }
        
        view.backgroundColor = .white
        title = "Book Details"
        
        setupImageView()
        setupStackView()
        setupLabels()
        
        // Setting the data from view model to UI
        
        let placeholderImage = UIImage(named: viewModel.imagePlaceholderName)
        imageView.kf.setImage(with: viewModel.imageURL, placeholder: placeholderImage, options: [.transition(.fade(0.3))])
        
        titleLabel.text = viewModel.title
        authorLabel.text = viewModel.author
        firstPublishYearLabel.text = viewModel.yearOfPublish
    }
    
    // MARK: - Setup
    
    private func setupImageView() {
        view.addSubview(imageView)
        imageView.backgroundColor = UIColor(red: 173.0/255.0, green: 173.0/255.0, blue: 173.0/255.0, alpha: 1)
        imageView.contentMode = .scaleAspectFit
    }
    
    private func setupStackView() {
        labelsStackView.axis = .vertical
        labelsStackView.spacing = Constants.standardSpacing
        labelsStackView.alignment = .top
    }
    
    private func setupLabels() {
        view.addSubview(labelsStackView)
        
        labelsStackView.addArrangedSubview(titleLabel)
        labelsStackView.addArrangedSubview(authorLabel)
        labelsStackView.addArrangedSubview(firstPublishYearLabel)
        
        labelsStackView.alignment = .top
        
        setupTitleLabel()
        setupAuthorLabel()
        setupPublishYearLabel()
    }
    
    private func setupTitleLabel() {
        titleLabel.font = .boldSystemFont(ofSize: 15.0)
        titleLabel.numberOfLines = 2
    }
    
    private func setupAuthorLabel() {
        authorLabel.font = .boldSystemFont(ofSize: 14.0)
        authorLabel.numberOfLines = 2
    }
    
    private func setupPublishYearLabel() {
        firstPublishYearLabel.font = .systemFont(ofSize: 13.0)
        firstPublishYearLabel.numberOfLines = 1
        firstPublishYearLabel.sizeToFit()
    }
}
