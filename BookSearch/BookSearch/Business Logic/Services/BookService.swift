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
    let apiClient = NetworkClientImp()
    
    func search(for searchString: String, page: Int, completion: @escaping (Result<BookSearchResult, ApiError>) -> Void)  {
        let searchEndpoint = BookEndpoint.search(keyword: searchString, page: page)
        apiClient.requestObject(endpoint: searchEndpoint) { (response: Result<BookSearchResult, ApiError>) in
            completion(response)
        }
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
