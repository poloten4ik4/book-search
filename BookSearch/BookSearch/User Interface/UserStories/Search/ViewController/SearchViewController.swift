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
    }
    
    private func layoutColletionView() {
        collectionView.frame = view.bounds
        let inset = UIEdgeInsets(top: Constants.searchBarHeight, left: 0, bottom: 0, right: 0)
        collectionView.contentInset = inset
        collectionView.scrollIndicatorInsets = inset
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
        searchBar.placeholder = viewModel.searchPlaceholder
        
        // NOTE: To save the time, I have added RxCocoa to do the throttling.
        searchBar.rx.text.compactMap { $0 }
            .debounce(RxTimeInterval.milliseconds(500), scheduler: MainScheduler.instance).subscribe(onNext: { [weak self] searchString in
                guard let self = self else { return }
                self.viewModel.search(for: searchString)
            }).disposed(by: disposeBag)
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
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let modelsCount = viewModel.dataSource.viewModels.count
        let preloadingTreashold = Int(Float(modelsCount) * 0.75)
        let threasholdReached = indexPath.item >= preloadingTreashold
        if !viewModel.isLoading && threasholdReached {
            viewModel.loadNextPage()
        }
    }
}
