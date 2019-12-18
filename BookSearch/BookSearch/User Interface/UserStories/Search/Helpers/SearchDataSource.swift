//
//  SearchDataSource.swift
//  BookSearch
//
//  Created by Zaslavskiy Mike on 18/12/2019.
//  Copyright © 2019 MikeZaslavskiy. All rights reserved.
//

import UIKit

class SearchDataSource: NSObject, UICollectionViewDataSource {
    
    // MARK: - Input
    
    var maximumNumberOfItems: Int = 0
    var viewModels: [BookCellViewModel] = []
    
    // MARK: - Output
    
    var onCellClick: ((BookCellInteractionType) -> ())?
    
    
    // MARK: - Inner properties
    
    private var shouldHaveLoadingCell: Bool {
        return viewModels.count != maximumNumberOfItems
    }
    
    // MARK: - UICollectionView DataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return shouldHaveLoadingCell ? viewModels.count + 1 : viewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        if shouldHaveLoadingCell && indexPath.row == maximumNumberOfItems {
//            // loading cell
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(LoadingCell.self), for: indexPath) as! LoadingCell
//        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(BookCollectionViewCell.self), for: indexPath) as! BookCollectionViewCell
            cell.configure(viewModels[indexPath.row])
//        }
        
        return cell
    }
}
