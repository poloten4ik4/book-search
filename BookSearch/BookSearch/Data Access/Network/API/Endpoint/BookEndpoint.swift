//
//  BooksEndpoint.swift
//  BookSearch
//
//  Created by Zaslavskiy Mike on 17/12/2019.
//  Copyright © 2019 MikeZaslavskiy. All rights reserved.
//

enum BookEndpoint {
    case search(keyword: String, page: Int)
}

extension BookEndpoint: Endpoint {
  
  var method: HTTPMethod {
    switch self {
    case .search:
      return .get
    }
  }
  
  var path: String {
    switch self {
    case .search:
      return "search.json"
    }
  }
  
  var headers: [String: String] {
    switch self {
    case .search(let keyword, let page):
        return ["title": keyword.replacingOccurrences(of: " ", with: "+"),
                "page": String(page)]
    }
  }
  
  var task: Task {
    return .request
  }
}
