//
//  BookService.swift
//  BookSearch
//
//  Created by Zaslavskiy Mike on 17/12/2019.
//  Copyright © 2019 MikeZaslavskiy. All rights reserved.
//

import Foundation

protocol BookServiceProtocol {
    func search(for searchString: String, page: Int, completion: @escaping (Result<BookSearchResult, ApiError>) -> Void)
    func addToWishList(_ bookInfo: BookInfo)
    func removeFromWishList(_ bookInfoKey: String)
    func obtainWishListBooks() -> [BookInfo]?
}

final class BookService: Service, BookServiceProtocol {
    let realmDataProvider = DataProvider()
    let translator = BookInfoTranslator()
    let apiClient = NetworkClientImp()
    
    func search(for searchString: String, page: Int, completion: @escaping (Result<BookSearchResult, ApiError>) -> Void)  {
        let searchEndpoint = BookEndpoint.search(keyword: searchString, page: page)
        apiClient.requestObject(endpoint: searchEndpoint) { (response: Result<BookSearchResult, ApiError>) in
            DispatchQueue.main.async {
                completion(response)
            }
        }
    }
    
    func addToWishList(_ bookInfo: BookInfo) {
        let persistableBook = translator.translate(bookInfo)
        realmDataProvider.add(persistableBook, update: true)
    }
    
    func removeFromWishList(_ bookInfoKey: String) {
        guard let objectToDelete = realmDataProvider.object(BookInfoPersistable.self, key: bookInfoKey) else {
            assertionFailure("Something went wrong with unique keys in Realm. Could not find an object to delete")
            return
        }
        realmDataProvider.delete(objectToDelete)
    }
    
    func obtainWishListBooks() -> [BookInfo]? {
        return realmDataProvider.objects(BookInfoPersistable.self)?.toArray(ofType: BookInfo.self)
    }
}
