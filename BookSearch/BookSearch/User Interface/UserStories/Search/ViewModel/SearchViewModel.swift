//
//  SearchViewModel.swift
//  BookSearch
//
//  Created by Zaslavskiy Mike on 17/12/2019.
//  Copyright © 2019 MikeZaslavskiy. All rights reserved.
//

import Foundation

class SearchViewModel {
    
   let dataSource = SearchDataSource()
    
    private let service = BookService()
    private var books: [BookInfo] = []
    private var page = 1
    private var lastSearchedString: String = ""
    
    // MARK: - Output
    
    var onReloadData: (() -> Void)?
    var onOpenDetail: ((BookInfo) -> Void)?
    
    // MARK: - Init
    
    init() {
        self.initialSetup()
    }
    
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
            service.search(for: searchString, page: page) { [weak self] result in
                guard let self = self else { return }
                
                if case .success(let bookSearchResult) = result {
                    self.processResult(bookSearchResult)
                    self.onReloadData?()
                } else {
                    // error state
                }
            }
        }
    }
    
    func performItemSelection(at indexPath: IndexPath) {
        onOpenDetail?(books[indexPath.row])
    }
    
    // MARK: - Private methods
    
    private func processResult(_ bookSearchResult: BookSearchResult) {
        // It's initial loading
        // We did not have any piece of data related to the search before
        if bookSearchResult.start == 0 {
            self.dataSource.maximumNumberOfItems = bookSearchResult.num_found
            self.dataSource.viewModels = bookSearchResult.docs.map { BookCellViewModel(with: $0) }
            self.books = bookSearchResult.docs
        } else {
            let nextPageBookViewModels = bookSearchResult.docs.map { BookCellViewModel(with: $0) }
            self.books.append(contentsOf: bookSearchResult.docs)
            self.dataSource.viewModels.append(contentsOf: nextPageBookViewModels)
        }
    }
    
    private func initialSetup() {
        dataSource.onCellTap = { [weak self] tapInfo in
            guard let self = self else { return }
            
            switch tapInfo.interactionType {
            case .main:
                let book = self.books[tapInfo.cellIndex]
                self.onOpenDetail?(book)
            case .wishList(let operationType):
                self.processWishListAction(elementIndex: tapInfo.cellIndex, type: operationType)
            }
        }
    }
    
    private func processWishListAction(elementIndex: Int, type: WishListOperationType) {
        let book = books[elementIndex]
        
        switch type {
        case .add:
            service.addToWishList(book)
        case .remove:
            // TODO: Ask about the primary key, maybe I can make it non optional
            guard let bookId = book.key else { return }
            service.removeFromWishList(bookId)
        }
        
        dataSource.updateViewModel(at: elementIndex, bookInfo: book)
        // TODO: Update the collection view cell at this index
    }
}
