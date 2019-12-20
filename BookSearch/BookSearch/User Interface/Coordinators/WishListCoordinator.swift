//
//  WishListCoordinator.swift
//  BookSearch
//
//  Created by Zaslavskiy Mike on 17/12/2019.
//  Copyright © 2019 MikeZaslavskiy. All rights reserved.
//

import UIKit

class WishListCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        guard let wishListViewController = navigationController.viewControllers.first as? WishListViewController else { return }
        
        wishListViewController.viewModel.onOpenDetail = { bookInfo in
            self.openDetail(bookInfo)
        }
    }
    
    private func openDetail(_ bookInfo: BookInfo) {
        let controller = ViewControllersFabric.createBookDetailViewController(bookInfo)
        navigationController.pushViewController(controller, animated: true)
    }
}
