//
//  BookService.swift
//  BookSearch
//
//  Created by Zaslavskiy Mike on 17/12/2019.
//  Copyright © 2019 MikeZaslavskiy. All rights reserved.
//

import Foundation
//import RealmSwift
import RxRealm
import RxSwift

protocol BookServiceProtocol {
    func search(for searchString: String, page: Int, cancelPreviousRequest: Bool,
                completion: @escaping (Result<BookSearchResult, ApiError>) -> Void)
    func addToWishList(_ bookInfo: BookInfo)
    func removeFromWishList(_ bookInfoKey: String)
    func obtainWishListBooks() -> [BookInfo]
    func isInWishList(book: BookInfo) ->Bool
}

final class BookService: Service, BookServiceProtocol {
    private let realmDataProvider = DataProvider()
    private let translator = BookInfoTranslator()
    private let apiClient = NetworkClientImp()
    private var requestQueue: [URLSessionDataTask] = []
    
    var booksInWishList: Observable<[BookInfo]>  {
        return Observable.array(from: realmDataProvider.objects(BookInfoPersistable.self))
            .map( { return $0.map({ self.translator.translate($0) })  })
    }
    
    func search(for searchString: String, page: Int, cancelPreviousRequest: Bool = true, completion: @escaping (Result<BookSearchResult, ApiError>) -> Void)  {
        
        if cancelPreviousRequest {
            requestQueue.forEach({ $0.cancel() })
            requestQueue.removeAll()
        }
        
        let searchEndpoint = BookEndpoint.search(keyword: searchString, page: page)

        let request = apiClient.requestObject(endpoint: searchEndpoint) { (response: Result<BookSearchResult, ApiError>) in
            DispatchQueue.main.async {
                completion(response)
            }
        }
        
        guard let validRequest = request else { return }
        requestQueue.append(validRequest)
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
    
    func obtainWishListBooks() -> [BookInfo] {
        return realmDataProvider.objects(BookInfoPersistable.self).map { translator.translate($0) }
    }
    
    func isInWishList(book: BookInfo) -> Bool {
        // We need to make this operation as fast as possible
        return true
    }
}
