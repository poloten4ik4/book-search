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
    private let labelsContainer = UIView()
    private let authorLabel = UILabel()
    private let titleLabel = UILabel()
    private let firstPublishYearLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let labelSpacing: CGFloat = 20.0
        let tabBarHeight = tabBarController?.tabBar.frame.height ?? 49.0
        let imageViewHeight = view.bounds.width
        let containerY = topbarHeight + imageViewHeight
        
        let labelsContainerWidth = view.bounds.width - 2 * labelSpacing
        let labelsContainerHeight = view.bounds.height - containerY - tabBarHeight
        
        imageView.frame = CGRect(x: 0, y: topbarHeight, width: view.bounds.width, height: imageViewHeight)
        
        labelsContainer.frame = CGRect(x: labelSpacing, y: containerY, width: labelsContainerWidth, height: labelsContainerHeight)
        titleLabel.frame = CGRect(x: 0, y: labelSpacing, width: labelsContainerWidth, height: titleLabel.intrinsicContentSize.height)
        
        let authorLabelY = titleLabel.intrinsicContentSize.height + labelSpacing * 2
        authorLabel.frame = CGRect(x: 0, y: authorLabelY, width: labelsContainerWidth, height: authorLabel.intrinsicContentSize.height)
        
        let firstPublishYearLabelY = titleLabel.intrinsicContentSize.height + authorLabel.intrinsicContentSize.height + labelSpacing * 3
        firstPublishYearLabel.frame = CGRect(x: 0, y: firstPublishYearLabelY, width: labelsContainerWidth,
                                             height: firstPublishYearLabel.intrinsicContentSize.height)
    }
    
    private func configureView() {
        guard let viewModel = self.viewModel else { return }
        setupImageView()
        setupLabels()
        
        imageView.kf.setImage(with: viewModel.imageURL, placeholder: UIImage(named: viewModel.imagePlaceholderName))
        
        titleLabel.text = viewModel.title
        authorLabel.text = viewModel.author
        firstPublishYearLabel.text = viewModel.yearOfPublish
    }
    
    private func setupImageView() {
        view.addSubview(imageView)
        imageView.backgroundColor = .gray
        imageView.contentMode = .scaleAspectFit
    }
    
    private func setupLabels() {
        view.addSubview(labelsContainer)
        
        labelsContainer.addSubview(titleLabel)
        labelsContainer.addSubview(authorLabel)
        labelsContainer.addSubview(firstPublishYearLabel)
        
        setupTitleLabel()
        setupAuthorLabel()
        setupPublishYearLabel()
    }
    
    private func setupTitleLabel() {
        titleLabel.font = .boldSystemFont(ofSize: 15.0)
        titleLabel.numberOfLines = 2
    }
    
    private func setupAuthorLabel() {
        authorLabel.font = .boldSystemFont(ofSize: 15.0)
        authorLabel.numberOfLines = 2
    }
    
    private func setupPublishYearLabel() {
        firstPublishYearLabel.font = .systemFont(ofSize: 13.0)
        firstPublishYearLabel.numberOfLines = 1
    }
}
