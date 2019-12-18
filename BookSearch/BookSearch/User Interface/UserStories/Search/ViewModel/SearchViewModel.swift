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
    let dataSource = SearchDataSource()
    var page = 1
    var lastSearchedString: String = ""
    
    // MARK: - Public/Interface
    func search(for searchString: String) {
        if searchString.count > 0 {
            // We need to check if we need to load the next page
            // Or we need to start the new search
            if searchString != lastSearchedString {
                page = 1
            } else {
                page += 1
            }
            
            lastSearchedString = searchString
            service.search(for: searchString, page: page) { result in
                if case .success(let bookSearchResult) = result {
                    self.processResult(bookSearchResult)
                } else {
                    // error state
                }
            }
        }

    }
    
    // MARK: - Private methods
    private func processResult(_ bookSearchResult: BookSearchResult) {
        // It's initial loading
        // We did not have any piece of data related to the search before
        if bookSearchResult.start == 0 {
            self.dataSource.maximumNumberOfItems = bookSearchResult.num_found
            self.dataSource.viewModels = bookSearchResult.docs.map { BookCellViewModel(with: $0) }
        } else {
            let nextPageBookViewModels = bookSearchResult.docs.map { BookCellViewModel(with: $0) }
            self.dataSource.viewModels.append(contentsOf: nextPageBookViewModels)
        }
    }
}
