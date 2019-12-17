//
//  BookService.swift
//  BookSearch
//
//  Created by Zaslavskiy Mike on 17/12/2019.
//  Copyright © 2019 MikeZaslavskiy. All rights reserved.
//

import Foundation

final class BookService: Service {
    let realmDataProvider = DataProvider()
    let translator = BookInfoTranslator()
    let apiClient = NetworkClientImp()
    
    func search(for searchString: String, page: Int, completion: @escaping (Result<BookSearchResult, ApiError>) -> Void)  {
        let searchEndpoint = BookEndpoint.search(keyword: searchString, page: page)
        apiClient.requestObject(endpoint: searchEndpoint) { (response: Result<BookSearchResult, ApiError>) in
            completion(response)
            guard let bookSearchResult = try? response.get() else { return }
            self.addToWishList(bookSearchResult.docs.first!)
        }
    }
    
    func addToWishList(_ book: BookInfo) {
        let persistableBook = translator.translate(book)
        realmDataProvider.add(persistableBook, update: true)
        print(realmDataProvider.objects(BookInfoPersistable.self))
    }
//    
//    func obtainWishList() -> [Book] {
//        realmDataProvider.objects(Book.self)
//    }
//    
//    func delete(_ book: Book) {
//        realmDataProvider.delete(book)
//    }
}
