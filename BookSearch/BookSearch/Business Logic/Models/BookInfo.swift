//
//  BookInfo.swift
//  BookSearch
//
//  Created by Zaslavskiy Mike on 17/12/2019.
//  Copyright © 2019 MikeZaslavskiy. All rights reserved.
//

struct BookInfo {
    let title: String
    let authors: [String]?
    let key: String?
    let isbn: [String]?
}

extension BookInfo: Decodable {
    enum CodingKeys: String, CodingKey {
        case title = "title"
        case authors = "author_name"
        case key = "key"
        case isbn = "isbn"
    }
}

struct BookSearchResult {
    let start: Int 
    let num_found: Int
    let docs: [BookInfo]
}

extension BookSearchResult: Decodable {}
