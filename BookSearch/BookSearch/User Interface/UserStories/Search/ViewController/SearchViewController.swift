//
//  SearchViewController.swift
//  BookSearch
//
//  Created by Zaslavskiy Mike on 17/12/2019.
//  Copyright © 2019 MikeZaslavskiy. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    let apiClient: NetworkClient = NetworkClientImp()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        apiClient.requestObject(endpoint: BookEndpoint.search(keywords: ["Lord"])) { (response: Result<BookSearchResult, ApiError>) in
          print(response)
        }
    }
}
