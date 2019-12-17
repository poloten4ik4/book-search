//
//  SearchViewModel.swift
//  BookSearch
//
//  Created by Zaslavskiy Mike on 17/12/2019.
//  Copyright © 2019 MikeZaslavskiy. All rights reserved.
//

import Foundation

class SearchViewModel {
    let service = BookService()
    
    func search(for searchString: String, page: Int = 1) {
        service.search(for: searchString, page: page) { result in
            print(result)
        }
    }
}
