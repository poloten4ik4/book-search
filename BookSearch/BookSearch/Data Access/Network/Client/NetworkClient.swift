//
//  NetworkClient.swift
//  swt
//
//  Created by alex kanchurin on 17.12.2019.
//  Copyright © 2019 alex kanchurin. All rights reserved.
//

import Foundation

enum NetworkError: Error {
    case transport(String)
    case wrongEndpoint
    case emptyResponse
    case unknown
}

protocol NetworkClient {
    func request(endpoint: Endpoint, response: @escaping (Result<Data, NetworkError>) -> Void)
}
