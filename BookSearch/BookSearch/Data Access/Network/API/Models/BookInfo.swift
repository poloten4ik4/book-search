//
//  BookInfo.swift
//  BookSearch
//
//  Created by Zaslavskiy Mike on 17/12/2019.
//  Copyright © 2019 MikeZaslavskiy. All rights reserved.
//

struct BookInfo {
  let title: String
  let author: [String]?
}

extension BookInfo: Decodable {

  enum CodingKeys: String, CodingKey {
    case title = "title"
    case author = "author_name"
  }
}

struct BookSearchResult {
  let docs: [BookInfo]
}

extension BookSearchResult: Decodable {}
