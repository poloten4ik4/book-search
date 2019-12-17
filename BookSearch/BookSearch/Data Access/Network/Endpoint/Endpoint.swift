//
//  Endpoint.swift
//  swt
//
//  Created by alex kanchurin on 17.12.2019.
//  Copyright © 2019 alex kanchurin. All rights reserved.
//

import Foundation

enum HTTPMethod: String {

  case get = "GET"
  
  case post = "POST"
}

enum Task {
  
  case request

  case requestData(Data)
}

protocol Endpoint {
  
  var method: HTTPMethod { get }
  
  var baseUrl: String { get }
  
  var path: String { get }
  
  var headers: [String: String] { get }
  
  var task: Task { get }
}
