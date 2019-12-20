//
//  BookInfoTranslator.swift
//  BookSearch
//
//  Created by Zaslavskiy Mike on 17/12/2019.
//  Copyright © 2019 MikeZaslavskiy. All rights reserved.
//

import Foundation
import RealmSwift

class BookInfoTranslator {
    func translate(_ bookInfo: BookInfo) -> BookInfoPersistable {
        let persistableBookInfo = BookInfoPersistable()
        let authorsList = List<String>()
        let isbnList = List<String>()
        
        if let authors = bookInfo.authors {
            authorsList.append(objectsIn: authors)
        }
        
        if let isbn = bookInfo.isbn {
            isbnList.append(objectsIn: isbn)
        }
        
        persistableBookInfo.title = bookInfo.title
        persistableBookInfo.key = bookInfo.key
        persistableBookInfo.isbn = isbnList
        persistableBookInfo.authors = authorsList
        persistableBookInfo.firstYearOfPulish = bookInfo.firstYearOfPulish
        
        return persistableBookInfo
    }
    
    func translate(_ bookInfo: BookInfoPersistable) -> BookInfo {        
        let bookInfo = BookInfo(title: bookInfo.title, authors: Array(bookInfo.authors), key: bookInfo.key,
                                isbn: Array(bookInfo.isbn), firstYearOfPulish: bookInfo.firstYearOfPulish)
        
        return bookInfo
    }
}
