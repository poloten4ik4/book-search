//
//  BookDetailViewModel.swift
//  BookSearch
//
//  Created by Zaslavskiy Mike on 18/12/2019.
//  Copyright © 2019 MikeZaslavskiy. All rights reserved.
//

import Foundation

struct BookDetailViewModel {
    let author: String
    let title: String
    let yearOfPublish: String
    let imageURL: URL?
    let imagePlaceholderName: String
    
    init(bookInfo: BookInfo) {
        author = "by " + (bookInfo.authors?.first ?? "Unknown author")
        title = bookInfo.title
        
        var publishYear = "Unknown"
        
        if let year = bookInfo.firstYearOfPulish {
            publishYear = String(describing: year)
        }
        
        yearOfPublish = "First year of publish: \(publishYear)"
       
        if let isbn = bookInfo.isbn?.first {
            let imageURLString = "http://covers.openlibrary.org/b/isbn/\(isbn)-L.jpg?default=false"
            imageURL = URL(string: imageURLString) ?? nil
        } else {
            imageURL = nil
        }
        
        imagePlaceholderName = "placeholderImage"
    }
}
