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

class BooksDataSource: NSObject, UICollectionViewDataSource {
    
    // MARK: - Input
    
    var viewModels: [BookCellViewModel] = []
    
    // MARK: - Output
    
    var onCellTap: ((SearchCellTapInfo) -> ())?
    
    // MARK: - Public methods
    
    // Cell view models are DTO's (plain objects and structures)
    // So in order to update the existance in wishList, need to recreate the model
    func updateViewModel(at index: Int, bookInfo: BookInfo, isInWishList: Bool) {
        let newModel = BookCellViewModel(with: bookInfo, isInWishList: isInWishList)
        viewModels[index] = newModel
    }
    
    // MARK: - UICollectionView DataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BookCell.reuseId, for: indexPath) as! BookCell
        
        // Not sure if we had a retain cycle here, maybe capture list is not mandatory
        cell.onTap = { [weak self] type in
            guard let self = self else { return }
            let tapInfo = SearchCellTapInfo(cellIndex: indexPath.row, interactionType: type)
            self.onCellTap?(tapInfo)
        }
        
        cell.configure(viewModels[indexPath.row])
        return cell
    }
}
