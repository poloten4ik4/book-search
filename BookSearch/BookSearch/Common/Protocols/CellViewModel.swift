//
//  Cell.swift
//  BookSearch
//
//  Created by Zaslavskiy Mike on 18/12/2019.
//  Copyright © 2019 MikeZaslavskiy. All rights reserved.
//

import Foundation

protocol CellViewModel {
    
}

protocol ConfigurableCell {
    associatedtype T
    func configure(_ viewModel: T)
}
