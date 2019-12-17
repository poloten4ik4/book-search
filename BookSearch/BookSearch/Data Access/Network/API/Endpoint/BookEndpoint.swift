//
//  BooksEndpoint.swift
//  BookSearch
//
//  Created by Zaslavskiy Mike on 17/12/2019.
//  Copyright © 2019 MikeZaslavskiy. All rights reserved.
//

enum BookEndpoint {
  case search(keywords: [String])
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
    case .search(let keywords):
      return ["title": keywords.joined(separator: "+")]
    }
  }
  
  var task: Task {
    return .request
  }
}
