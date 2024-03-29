//
//  WishListViewController.swift
//  BookSearch
//
//  Created by Zaslavskiy Mike on 17/12/2019.
//  Copyright © 2019 MikeZaslavskiy. All rights reserved.
//

import UIKit

class WishListViewController: UIViewController {
    
    var viewModel: WishListViewModel!
    
    // MARK: - UI elements
    
    let collectionView: UICollectionView = {
        let layout = SearchCollectionLayout()
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()
    
    let emptyResultsLabel: UILabel = {
        let emptyLabel = UILabel()
        emptyLabel.numberOfLines = 1
        emptyLabel.font = .systemFont(ofSize: 15)
        emptyLabel.isHidden = true
        emptyLabel.textAlignment = .center
        return emptyLabel
    }()
    
    let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        return indicator
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
        viewModel.obtainBooks()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        layoutViews()
    }
    
    // MARK: - Layout
    private func layoutViews() {
        layoutColletionView()
        layoutEmptyLabel()
        layoutLoadingIndicator()
    }
    
    private func layoutColletionView() {
        collectionView.frame = CGRect(x: 0,
                                      y: topbarHeight,
                                      width: view.bounds.width,
                                      height: view.bounds.height - topbarHeight)
        guard let layout = collectionView.collectionViewLayout as? SearchCollectionLayout else {
            assertionFailure("Layout is in danger")
            return
        }
        layout.itemSize = layout.getCellSize()
    }
    
    private func layoutLoadingIndicator() {
        loadingIndicator.frame = view.bounds
    }
    
    private func layoutEmptyLabel() {
        emptyResultsLabel.frame = view.bounds
    }
    
    // MARK: - Private. Setup
    
    private func setupUI() {
        navigationItem.title = "Books wishlist"
        view.backgroundColor = .white
        setupCollectionView()
        setupEmptyLabel()
    }
    
    private func setupCollectionView() {
        view.addSubview(collectionView)
        collectionView.register(BookCell.self, forCellWithReuseIdentifier: BookCell.reuseId)
        collectionView.dataSource = viewModel.dataSource
        collectionView.delegate = self
        collectionView.backgroundColor = .white
    }
    
    private func setupEmptyLabel() {
        view.addSubview(emptyResultsLabel)
        emptyResultsLabel.text = viewModel.noResultsText
    }
    
    private func setupActions() {
        viewModel.onReloadData = { [weak self] in
            self?.collectionView.reloadData()
        }
        
        viewModel.onUpdateEmptyResultsVisibility = { [weak self] shouldShowEmptyLabel in
            guard let self = self else { return }
            self.emptyResultsLabel.isHidden = !shouldShowEmptyLabel
        }
    }
}

extension WishListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.performItemSelection(at: indexPath)
    }
}
