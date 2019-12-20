//
//  NetworkClientImp.swift
//  swt
//
//  Created by alex kanchurin on 17.12.2019.
//  Copyright © 2019 alex kanchurin. All rights reserved.
//

import Foundation

final class NetworkClientImp {
    private var session: URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 3
        let session = URLSession(configuration: configuration)
        return session
    }()
}

// MARK: - NetworkClient

extension NetworkClientImp: NetworkClient {
    func request(endpoint: Endpoint, response: @escaping (Result<Data, NetworkError>) -> Void) -> URLSessionDataTask? {
        
        guard var components = URLComponents(string: endpoint.fullPath) else {
            response(.failure(.wrongEndpoint))
            return nil
        }
        
        components.queryItems = endpoint.headers.map { URLQueryItem(name: $0.0, value: $0.1) }
        
        guard let url = components.url else {
            response(.failure(.wrongEndpoint))
            return nil
        }
        
        var request = URLRequest(url: url)
        
        switch endpoint.task {
        case .request:
            break
            
        case .requestData(let data):
            request.httpBody = data
        }
        
        
        let task = session.dataTask(with: request) { data, resp, error in
            if let error = error {
                response(.failure(.transport(error.localizedDescription)))
                return
            }
            
            guard let data = data else {
                response(.failure(.emptyResponse))
                return
            }
            
            response(.success(data))
        }
        
        task.resume()
        
        return task
    }
}

// MARK: - Private. Helpers

private extension Endpoint {
    var fullPath: String {
        var finalBase = baseUrl
        if !finalBase.hasSuffix("/") {
            finalBase += "/"
        }
        
        var finalPath = path
        if !finalPath.hasSuffix("/") {
            finalPath += "/"
        }
        
        return finalBase + finalPath
    }
}
