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
        static let searchBarHeight: CGFloat = 44
    }
    
    var viewModel: SearchViewModel!

    // MARK: - UI elements
    
    let collectionView: UICollectionView = {
        let layout = SearchCollectionLayout()
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()
    
    let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        return searchBar
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Search for books"
        
        setupUI()
        setupActions()
        
        viewModel.search(for: "New york")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        layoutViews()
    }
    
    // MARK: - Layout
    private func layoutViews() {
        layoutColletionView()
        layoutSearchBar()
    }
    
    private func layoutColletionView() {
        collectionView.frame = view.bounds
        (collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.itemSize = getCellSize()
    }
    
    private func layoutSearchBar() {
        let origin = CGPoint(x: 0, y: topbarHeight)
        let size = CGSize(width: view.bounds.width, height: Constants.searchBarHeight)
        searchBar.frame = CGRect(origin: origin, size: size)
    }
    
    // MARK: - Private. Setup
    
    private func setupUI() {
        view.backgroundColor = .white
        setupCollectionView()
        setupSearchBar()
    }
    
    private func setupCollectionView() {
        view.addSubview(collectionView)
        collectionView.register(BookCell.self, forCellWithReuseIdentifier: BookCell.reuseId)
        collectionView.dataSource = viewModel.dataSource
        collectionView.delegate = self
        collectionView.backgroundColor = .white
    }
    
    private func setupSearchBar() {
        view.addSubview(searchBar)
        searchBar.delegate = self
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

extension SearchViewController: UISearchBarDelegate {
    
}
