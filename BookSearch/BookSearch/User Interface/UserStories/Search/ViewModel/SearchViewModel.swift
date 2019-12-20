//
//  SearchViewModel.swift
//  BookSearch
//
//  Created by Zaslavskiy Mike on 17/12/2019.
//  Copyright © 2019 MikeZaslavskiy. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay

class SearchViewModel {
    
    let dataSource = BooksDataSource()
    let searchPlaceholder = "Search for books"
    let noResultsText = "Sorry, we couldn't find anything"
    let errorText = "Error. Please try again later"
    var isLoading = false
    var isNextPageLoadingInProcess = false
    let searchEvent = BehaviorRelay<String?>(value: nil)
    
    private let service = BookService()
    private var books: [BookInfo] = []
    private var page = 1
    private var lastSearchedString: String = ""
    private var maximumNumberOfItems: Int = 0
    private let disposeBag = DisposeBag()
    private var booksInWishListSet = Set<BookInfo>()
    
    
    // MARK: - Output
    
    var onReloadData: (() -> Void)?
    var onUpdateCell: ((Int) -> Void)?
    var onOpenDetail: ((BookInfo) -> Void)?
    var onScrollToTop: (() -> Void)?
    
    // We can to RX bindings here but for simplicity, I will avoid it here
    
    var onUpdateEmptyResultsVisibility: ((Bool) -> Void)?
    var onUpdateErrorVisibility: ((Bool) -> Void)?
    var onShowLoading: ((Bool) -> Void)?
    
    // MARK: - Init
    
    init() {
        self.initialSetup()
    }
    
    // MARK: - Public/Interface
    
    @objc func search(for searchString: String) {        
        if searchString.count > 0 {
            updateLoadedPageIfNeeded(searchString: searchString)
            lastSearchedString = searchString
            
            if page > 1 {
                isNextPageLoadingInProcess = true
            } else {
                // If the search is new - clear the data source and update UI
                clearData()
                onReloadData?()
                onUpdateEmptyResultsVisibility?(false)
                onUpdateErrorVisibility?(false)
            }
            
            onShowLoading?(true)
            
            service.search(for: searchString, page: page) { [weak self] result in
                guard let self = self else { return }
                self.onShowLoading?(false)
                
                if case .success(let bookSearchResult) = result {
                    self.isNextPageLoadingInProcess = false
                    self.processResult(bookSearchResult)
                    self.onReloadData?()
                    self.onUpdateEmptyResultsVisibility?(bookSearchResult.num_found == 0)
                    self.onUpdateErrorVisibility?(false)
                    // We can be in the middle of collection view
                    // To show new search result, we need to scroll up
                    if self.page == 1 {
                        self.onScrollToTop?()
                    }
                } else if case .failure(let error) = result {
                    if error != .cancelled {
                        self.onUpdateErrorVisibility?(true)
                        self.onUpdateEmptyResultsVisibility?(false)
                    }
                }
            }
        }
    }
    
    func loadNextPage() {
        guard !isNextPageLoadingInProcess else { return }
        if maximumNumberOfItems != books.count {
            search(for: lastSearchedString)
        }
    }
    
    func performItemSelection(at indexPath: IndexPath) {
        onOpenDetail?(books[indexPath.row])
    }
    
    // MARK: - Private methods
    
    private func updateLoadedPageIfNeeded(searchString: String) {
        // We need to check if we need to load the next page
        // Or we need to start the new search
        if searchString != lastSearchedString {
            page = 1
        } else {
            page += 1
        }
    }
    
    private func processResult(_ bookSearchResult: BookSearchResult) {
        // It's initial loading
        // We did not have any piece of data related to the search before
        if bookSearchResult.start == 0 {
            self.maximumNumberOfItems = bookSearchResult.num_found
            self.dataSource.viewModels = bookSearchResult.docs.map { BookCellViewModel(with: $0, isInWishList: booksInWishListSet.contains($0)) }
            self.books = bookSearchResult.docs
        } else {
            let nextPageBookViewModels = bookSearchResult.docs.map { BookCellViewModel(with: $0, isInWishList: booksInWishListSet.contains($0)) }
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
        
        service.booksInWishList.subscribe(onNext: { [weak self] (books) in
            guard let self = self else { return }
            self.booksInWishListSet = Set(books)
        }).disposed(by: disposeBag)
        
        booksInWishListSet = Set(service.obtainWishListBooks())
        
        searchEvent.distinctUntilChanged()
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] text in
                guard let self = self else { return }
                
                guard let text = text, !text.isEmpty else {
                    self.clearData()
                    self.onReloadData?()
                    self.onUpdateEmptyResultsVisibility?(false)
                    self.onUpdateErrorVisibility?(false)
                    return
                }
                
                self.search(for: text)
                
            }).disposed(by: disposeBag)
        
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
        
        onUpdateCell?(elementIndex)
    }
    
    private func clearData() {
        self.maximumNumberOfItems = 0
        self.dataSource.viewModels = []
        self.books = []
    }
}
