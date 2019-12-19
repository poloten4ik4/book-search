//
//  SearchViewController.swift
//  BookSearch
//
//  Created by Zaslavskiy Mike on 17/12/2019.
//  Copyright © 2019 MikeZaslavskiy. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    
    private enum Constants {
        static let spacing: CGFloat = 16
    }
    
    var viewModel: SearchViewModel!

    let collectionView: UICollectionView = {
        let layout = SearchCollectionLayout()
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()
    
    // MARK: - Override
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Search for books"
        
        setupUI()
        setupActions()
        
        viewModel.search(for: "New york")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
        (collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.itemSize = getCellSize()
    }
    
    // MARK: - Private. Setup
    
    private func setupUI() {
        view.backgroundColor = .white
        
        view.addSubview(collectionView)
        collectionView.register(BookCell.self, forCellWithReuseIdentifier: BookCell.reuseId)
        collectionView.dataSource = viewModel.dataSource
        collectionView.delegate = self
        collectionView.backgroundColor = .white
    }
    
    private func setupActions() {
        viewModel.onReloadData = { [weak self] in
            self?.collectionView.reloadData()
        }
    }
    
    // MARK: - Private. Helpers
    
    private func getCellSize() -> CGSize {
        let width = collectionView.bounds.width
        let cellWidth = (width - 3 * Constants.spacing) / 2
        return CGSize(width: cellWidth, height: BookCell.height)
    }
}

extension SearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.performItemSelection(at: indexPath)
    }
}
