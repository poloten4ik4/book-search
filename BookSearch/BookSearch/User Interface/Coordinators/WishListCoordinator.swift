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
        // TODO: Implement Wish List flow start
    }
    
    private func openDetail(_ bookInfo: BookInfo) {
        let controller = ViewControllersFabric().createBookDetailViewController(bookInfo)
        navigationController.pushViewController(controller, animated: true)
    }
}
