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
    let searchPlaceholder = "Search for books"
    var isLoading = false
    
    private let service = BookService()
    private var books: [BookInfo] = []
    private var page = 1
    private var lastSearchedString: String = ""
    private var maximumNumberOfItems: Int = 0
    
    // MARK: - Output
    
    var onReloadData: (() -> Void)?
    var onOpenDetail: ((BookInfo) -> Void)?
    
    // MARK: - Init
    
    init() {
        self.initialSetup()
    }
    
    // MARK: - Public/Interface
    
    @objc func search(for searchString: String) {        
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
    
    func loadNextPage() {
        if maximumNumberOfItems != books.count {
            print("load more")
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
            // TODO: add database for isInWishList property
            self.maximumNumberOfItems = bookSearchResult.num_found
            self.dataSource.viewModels = bookSearchResult.docs.map { BookCellViewModel(with: $0, isInWishList: true) }
            self.books = bookSearchResult.docs
        } else {
            // TODO: add database for isInWishList property
            let nextPageBookViewModels = bookSearchResult.docs.map { BookCellViewModel(with: $0, isInWishList: true) }
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
        // TODO: add database for isInWishList property
        dataSource.updateViewModel(at: elementIndex, bookInfo: book, isInWishList: true)
        // TODO: Update the collection view cell at this index
    }
}
