//
//  SearchViewController.swift
//  BookSearch
//
//  Created by Zaslavskiy Mike on 17/12/2019.
//  Copyright © 2019 MikeZaslavskiy. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class SearchViewController: UIViewController {
    
    private enum Constants {
        static let spacing: CGFloat = 16
        static let searchBarHeight: CGFloat = 44
    }
    
    var viewModel: SearchViewModel!
    
    private let disposeBag = DisposeBag()
    
    // MARK: - UI elements
    
    let collectionView: UICollectionView = {
        let layout = SearchCollectionLayout()
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()
    
    let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        return searchBar
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
        navigationItem.title = "Search for books"
        
        setupUI()
        setupActions()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        layoutViews()
    }
    
    // MARK: - Layout
    private func layoutViews() {
        layoutColletionView()
        layoutSearchBar()
        layoutEmptyLabel()
        layoutLoadingIndicator()
    }
    
    private func layoutColletionView() {
        collectionView.frame = CGRect(x: 0,
                                      y: Constants.searchBarHeight + topbarHeight,
                                      width: view.bounds.width,
                                      height: view.bounds.height - Constants.searchBarHeight - topbarHeight)
        (collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.itemSize = getCellSize()
    }
    
    private func layoutSearchBar() {
        let origin = CGPoint(x: 0, y: topbarHeight)
        let size = CGSize(width: view.bounds.width, height: Constants.searchBarHeight)
        searchBar.frame = CGRect(origin: origin, size: size)
    }
    
    private func layoutLoadingIndicator() {
        loadingIndicator.frame = view.bounds
    }
    
    private func layoutEmptyLabel() {
        emptyResultsLabel.frame = view.bounds
    }
    
    // MARK: - Private. Setup
    
    private func setupUI() {
        view.backgroundColor = .white
        setupCollectionView()
        setupSearchBar()
        setupEmptyLabel()
        setupLoadingIndicator()
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
    
    private func setupLoadingIndicator() {
        view.addSubview(loadingIndicator)
    }
    
    private func setupSearchBar() {
        view.addSubview(searchBar)
        searchBar.placeholder = viewModel.searchPlaceholder
        
        // NOTE: To save the time, I have added RxCocoa to do the throttling.
        searchBar.rx.text.bind(to: viewModel.searchEvent).disposed(by: disposeBag)
    }
    
    private func setupActions() {
        viewModel.onReloadData = { [weak self] in
            self?.collectionView.reloadData()
        }
        
        viewModel.onScrollToTop = { [weak self] in
            guard let self = self else { return }
            self.collectionView.setContentOffset(CGPoint(x: 0, y: -50), animated: false)
        }
        
        viewModel.onUpdateEmptyResultsVisibility = { [weak self] shouldShowEmptyLabel in
            guard let self = self else { return }
            self.emptyResultsLabel.isHidden = !shouldShowEmptyLabel
        }
        
        viewModel.onShowLoading = { [weak self] shouldShowLoading in
            guard let self = self else { return }
            shouldShowLoading ? self.loadingIndicator.startAnimating() : self.loadingIndicator.stopAnimating()
        }
        
        viewModel.onUpdateCell = { [weak self] cellIndex in
            guard let self = self else { return }
            self.collectionView.reloadItems(at: [IndexPath(row: cellIndex, section: 0)])
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
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        // This is the silent page loading logic
        // If we reach 75% of the collection view - the next page will start loading
        let modelsCount = viewModel.dataSource.viewModels.count
        let preloadingTreashold = Int(Float(modelsCount) * 0.75)
        let threasholdReached = indexPath.item >= preloadingTreashold
        if !viewModel.isLoading && threasholdReached {
            viewModel.loadNextPage()
        }
    }
}
