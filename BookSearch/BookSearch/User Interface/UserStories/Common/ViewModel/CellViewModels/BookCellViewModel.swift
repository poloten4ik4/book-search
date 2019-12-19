//
//  BookCellViewModel.swift
//  BookSearch
//
//  Created by Zaslavskiy Mike on 18/12/2019.
//  Copyright © 2019 MikeZaslavskiy. All rights reserved.
//

import Foundation

struct BookCellViewModel {
    let title: String
    let imageURL: URL?
    let imagePlaceholderName: String
    
    init(with bookInfo: BookInfo) {
        self.title = bookInfo.title
        if let isbn = bookInfo.isbn?.first {
            let imageURLString = "http://covers.openlibrary.org/b/isbn/\(isbn)-S.jpg?default=false"
            imageURL = nil//URL(string: imageURLString) ?? nil
        } else {
            imageURL = nil
        }
        
        imagePlaceholderName = "placeholderImage"
    }
}
