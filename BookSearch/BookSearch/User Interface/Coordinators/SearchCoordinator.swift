//
//  SearchCoordinator.swift
//  BookSearch
//
//  Created by Zaslavskiy Mike on 17/12/2019.
//  Copyright © 2019 MikeZaslavskiy. All rights reserved.
//

import UIKit

class SearchCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        guard let searchViewController = navigationController.viewControllers.first as? SearchViewController else { return }
        
        searchViewController.viewModel.onOpenDetail = { bookInfo in
            self.openDetail(bookInfo)
        }
    }

    private func openDetail(_ bookInfo: BookInfo) {
        // TODO: Provide year of publish
        let bookDetailViewModel = BookDetailViewModel.init(title: bookInfo.title, yearOfPublish: "1566")
        let bookDetailViewController = BookDetailViewController()
        bookDetailViewController.viewModel = bookDetailViewModel
        bookDetailViewController.title = "Book Details"
        navigationController.pushViewController(bookDetailViewController, animated: true)
    }
}
