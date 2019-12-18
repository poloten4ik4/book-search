//
//  BookCollectionViewCell.swift
//  BookSearch
//
//  Created by Zaslavskiy Mike on 18/12/2019.
//  Copyright © 2019 MikeZaslavskiy. All rights reserved.
//

import UIKit


enum WishListOperationType {
    case add
    case remove
}

enum BookCellInteractionType {
    case wishList(WishListOperationType)
    case main
}

class BookCollectionViewCell: UICollectionViewCell {
    
    var onTap: ((BookCellInteractionType) -> ())?
    
    func configure(_ viewModel: BookCellViewModel) {
        print(viewModel)
    }
    
    
    // TODO: Add actions
    func addToWishList() {
        // Need to take UI's state of button - is selected or not, or keep the view model inside cell
        onTap?(.wishList(.add))
    }

}
