//
//  WishListViewModel.swift
//  BookSearch
//
//  Created by Zaslavskiy Mike on 20/12/2019.
//  Copyright © 2019 MikeZaslavskiy. All rights reserved.
//

import Foundation
import RxSwift

class WishListViewModel {
    
    let dataSource = BooksDataSource()
    let noResultsText = "No books in wishlist"
    var isNextPageLoadingInProcess = false
    
    private let service = BookService()
    private var books: [BookInfo] = []
    private let disposeBag = DisposeBag()
    
    // MARK: - Output
    
    var onReloadData: (() -> Void)?
    var onUpdateCell: ((Int) -> Void)?
    var onOpenDetail: ((BookInfo) -> Void)?
    
    // We can to RX bindings here but for simplicity, I will avoid it here
    
    var onUpdateEmptyResultsVisibility: ((Bool) -> Void)?
    
    // MARK: - Init
    
    init() {
        self.initialSetup()
    }
    
    // MARK: - Public/Interface
    
    func performItemSelection(at indexPath: IndexPath) {
        onOpenDetail?(books[indexPath.row])
    }
    
    func obtainBooks() {
        // TODO: Ideally, we don't need to recreate an array of books each time
        // This need to be improved. But because of the time limit it will be ommited
        // In real world apps, I would just monitor new updates, when a few books are added
        // Without recreating the whole array again and again
        service.booksInWishList.subscribe(onNext: { [weak self] (books) in
            guard let self = self else { return }
            self.books = books
            self.dataSource.viewModels = books.map { BookCellViewModel(with: $0, isInWishList: true) }
            self.onUpdateEmptyResultsVisibility?(books.isEmpty)
            self.onReloadData?()
        }).disposed(by: disposeBag)
    }
    
    // MARK: - Private methods
    
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
            dataSource.updateViewModel(at: elementIndex, bookInfo: book, isInWishList: true)
        case .remove:
            service.removeFromWishList(book.key)
            dataSource.updateViewModel(at: elementIndex, bookInfo: book, isInWishList: false)
        }
        
        onReloadData?()
    }
}

