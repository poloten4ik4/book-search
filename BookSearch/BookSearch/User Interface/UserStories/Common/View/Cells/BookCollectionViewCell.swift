//
//  BookCollectionViewCell.swift
//  BookSearch
//
//  Created by Zaslavskiy Mike on 18/12/2019.
//  Copyright © 2019 MikeZaslavskiy. All rights reserved.
//

import UIKit

enum BookCellInteractionType {
    case wishList
    case main
}

class BookCollectionViewCell: UICollectionViewCell {
    
    var onClick: ((BookCellInteractionType) -> ())?
    
    func configure(_ viewModel: BookCellViewModel) {
        print(viewModel)
    }
    
    
    // TODO: Add actions
    func addToWishList() {
        onClick?(.wishList)
    }

}
