//
//  BookInfo.swift
//  BookSearch
//
//  Created by Zaslavskiy Mike on 17/12/2019.
//  Copyright © 2019 MikeZaslavskiy. All rights reserved.
//

struct BookInfo: Equatable, Hashable {
    let title: String
    let authors: [String]?
    let key: String
    let isbn: [String]?
    let firstYearOfPulish: Int?
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(key)
    }
    
    static func ==(lhs: BookInfo, rhs: BookInfo) -> Bool {
        return lhs.key == rhs.key
    }
}

extension BookInfo: Decodable {
    enum CodingKeys: String, CodingKey {
        case title = "title"
        case authors = "author_name"
        case key = "key"
        case isbn = "isbn"
        case firstYearOfPulish = "first_publish_year"
    }
}

struct BookSearchResult {
    let start: Int 
    let num_found: Int
    let docs: [BookInfo]
}

extension BookSearchResult: Decodable {}
