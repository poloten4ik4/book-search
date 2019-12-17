//
//  ApiClient.swift
//  BookSearch
//
//  Created by Zaslavskiy Mike on 17/12/2019.
//  Copyright © 2019 MikeZaslavskiy. All rights reserved.
//

import Foundation

enum ApiError: Error {
  
  case decodingError
  
  case pizdec
}

extension NetworkClient {
  
  func requestObject<T: Decodable>(endpoint: Endpoint, response: @escaping (Result<T, ApiError>) -> Void) {
    request(endpoint: endpoint) { result in
      switch result {
      case .success(let data):
        guard let obj = try? JSONDecoder().decode(T.self, from: data) else {
          response(.failure(.decodingError))
          return
        }
        
        response(.success(obj))
        
      case .failure(let networkError):
        response(.failure(.pizdec))
      }
    }
  }
}
