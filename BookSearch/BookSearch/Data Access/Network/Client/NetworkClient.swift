//
//  NetworkClient.swift
//  swt
//
//  Created by Zaslavskiy Mike on 17.12.2019.
//  Copyright © 2019 Zaslavskiy Mike. All rights reserved.
//

import Foundation

enum NetworkError: Error {
    case transport(String)
    case wrongEndpoint
    case emptyResponse
    case unknown
}

protocol NetworkClient {
    func request(endpoint: Endpoint, response: @escaping (Result<Data, NetworkError>) -> Void) -> URLSessionDataTask?
}
