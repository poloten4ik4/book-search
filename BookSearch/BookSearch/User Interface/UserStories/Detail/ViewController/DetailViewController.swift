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
    private let labelsContainerView = UIView()
    private let titleAndAuthorLabel = UILabel()
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
        layoutContainerView()
        layoutLabels()
    }
    
    private func layoutImageView() {
        let origin = CGPoint(x: 0, y: topbarHeight)
        // Let's assume it's a square image view
        let size = CGSize(width: view.bounds.width, height: view.bounds.width)
        imageView.frame = CGRect(origin: origin, size: size)
    }
    
    private func layoutContainerView() {
        let containerViewY = topbarHeight + view.bounds.width + Constants.standardSpacing
        let containerViewWidth = view.bounds.width - 2 * Constants.standardSpacing
        let containerViewHeight = Constants.standardSpacing + firstPublishYearLabel.intrinsicContentSize.height + titleAndAuthorLabel.intrinsicContentSize.height
        
        let origin = CGPoint(x: Constants.standardSpacing, y: containerViewY)
        let size = CGSize(width: containerViewWidth, height: containerViewHeight)
        
        labelsContainerView.frame = CGRect(origin: origin, size: size)
    }
    
    private func layoutLabels() {
        let width = view.bounds.width - 2 * Constants.standardSpacing
        titleAndAuthorLabel.frame = CGRect(origin: .zero, size: CGSize(width: width, height: titleAndAuthorLabel.intrinsicContentSize.height))
        
        let publishYearOrigin = CGPoint(x: 0, y: titleAndAuthorLabel.intrinsicContentSize.height + Constants.standardSpacing)
        firstPublishYearLabel.frame = CGRect(origin: publishYearOrigin, size: CGSize(width: width, height: firstPublishYearLabel.intrinsicContentSize.height))
    }
    
    // MARK: - Configuration
    
    private func configureView() {
        guard let viewModel = self.viewModel else { return }
        
        view.backgroundColor = .white
        title = "Book Details"
        
        setupImageView()
        setupLabels()
        
        // Setting the data from view model to UI
        
        let placeholderImage = UIImage(named: viewModel.imagePlaceholderName)
        imageView.kf.setImage(with: viewModel.imageURL, placeholder: placeholderImage, options: [.transition(.fade(0.3))])
        
        titleAndAuthorLabel.text = viewModel.titleAndAuthor
        firstPublishYearLabel.text = viewModel.yearOfPublish
    }
    
    // MARK: - Setup
    
    private func setupImageView() {
        view.addSubview(imageView)
        imageView.backgroundColor = UIColor.warmGrayColor
        imageView.contentMode = .scaleAspectFit
    }
    
    private func setupLabels() {
        view.addSubview(labelsContainerView)
        
        labelsContainerView.addSubview(titleAndAuthorLabel)
        labelsContainerView.addSubview(firstPublishYearLabel)
        
        setupTitleAndAuthorLabel()
        setupPublishYearLabel()
    }
    
    private func setupTitleAndAuthorLabel() {
        titleAndAuthorLabel.font = .boldSystemFont(ofSize: 15.0)
        titleAndAuthorLabel.numberOfLines = 2
    }
    
    private func setupPublishYearLabel() {
        firstPublishYearLabel.font = .systemFont(ofSize: 13.0)
        firstPublishYearLabel.numberOfLines = 1
        firstPublishYearLabel.sizeToFit()
    }
}
