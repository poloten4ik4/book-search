//
//  SearchDataSource.swift
//  BookSearch
//
//  Created by Zaslavskiy Mike on 18/12/2019.
//  Copyright © 2019 MikeZaslavskiy. All rights reserved.
//

import UIKit

struct SearchCellTapInfo {
    let cellIndex: Int
    let interactionType: BookCellInteractionType
}

class SearchDataSource: NSObject, UICollectionViewDataSource {
    
    // MARK: - Input
    
    var maximumNumberOfItems: Int = 0
    var viewModels: [BookCellViewModel] = []
    
    // MARK: - Output
    
    var onCellTap: ((SearchCellTapInfo) -> ())?
    
    // MARK: - Inner properties
    
    private var shouldHaveLoadingCell: Bool {
        return viewModels.count != maximumNumberOfItems
    }
    
    // MARK: - Public methods
    
    // Cell view models are DTO's (plain objects and structures)
    // So in order to update the existance in wishList, need to recreate the model
    func updateViewModel(at index: Int, bookInfo: BookInfo) {
        let newModel = BookCellViewModel(with: bookInfo)
        viewModels[index] = newModel
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
        
            // Not sure if we had a retain cycle here, maybe capture list is not mandatory
            // TODO: check for leak
            cell.onTap = { [weak self] type in
                guard let self = self else { return }
                let tapInfo = SearchCellTapInfo(cellIndex: indexPath.row, interactionType: type)
                self.onCellTap?(tapInfo)
            }
            
            cell.configure(viewModels[indexPath.row])
//        }
        
        return cell
    }
}
