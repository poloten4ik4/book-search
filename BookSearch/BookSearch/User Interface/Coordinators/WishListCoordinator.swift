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
    
    func start() {
        
    }
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
}
