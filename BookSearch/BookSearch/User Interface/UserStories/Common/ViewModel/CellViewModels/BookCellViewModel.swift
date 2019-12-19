//
//  BookCellViewModel.swift
//  BookSearch
//
//  Created by Zaslavskiy Mike on 18/12/2019.
//  Copyright © 2019 MikeZaslavskiy. All rights reserved.
//

import Foundation

struct BookCellViewModel {
    let titleWithAuthor: String
    let imageURL: URL?
    let imagePlaceholderName: String
    
    init(with bookInfo: BookInfo) {
        
        var titleAndAuthorString = bookInfo.title
        
        if let author = bookInfo.authors?.first {
            titleAndAuthorString = bookInfo.title + " by \(author)"
        }
        
        self.titleWithAuthor = titleAndAuthorString
        
        if let isbn = bookInfo.isbn?.first {
            let imageURLString = "http://covers.openlibrary.org/b/isbn/\(isbn)-M.jpg?default=false"
            imageURL = URL(string: imageURLString) ?? nil
        } else {
            imageURL = nil
        }
        
        imagePlaceholderName = "placeholderImage"
    }
}
