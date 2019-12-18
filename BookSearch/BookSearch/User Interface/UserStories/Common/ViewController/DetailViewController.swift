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
    
    
    // MARK: - Lyfecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureView()
    }
    
    // MARK: - Layout
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let labelSpacing: CGFloat = 20.0
        let tabBarHeight = tabBarController?.tabBar.frame.height ?? 49.0
        let imageViewHeight = view.bounds.width
        let containerY = topbarHeight + imageViewHeight
        
        let labelsContainerWidth = view.bounds.width - 2 * labelSpacing
        let labelsContainerHeight = view.bounds.height - containerY - tabBarHeight
        
        imageView.frame = CGRect(x: 0, y: topbarHeight, width: view.bounds.width, height: imageViewHeight)
        labelsStackView.frame = CGRect(x: labelSpacing, y: containerY, width: labelsContainerWidth, height: labelsContainerHeight)
    }
    
    // MARK: - Configuration
    
    private func configureView() {
        guard let viewModel = self.viewModel else { return }
        setupImageView()
        setupStackView()
        setupLabels()
        
        // Setting the data from view model to UI
        imageView.kf.setImage(with: viewModel.imageURL, placeholder: UIImage(named: viewModel.imagePlaceholderName))
        
        titleLabel.text = viewModel.title
        authorLabel.text = viewModel.author
        firstPublishYearLabel.text = viewModel.yearOfPublish
    }
    
    // MARK: - Setup
    
    private func setupImageView() {
        view.addSubview(imageView)
        imageView.backgroundColor = .gray
        imageView.contentMode = .scaleAspectFit
    }
    
    private func setupStackView() {
        labelsStackView.axis = .vertical
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
    
    // MARK: - Labels Setup
    
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
