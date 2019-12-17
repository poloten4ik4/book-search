//
//  TabBarCoordinator.swift
//  BookSearch
//
//  Created by Zaslavskiy Mike on 17/12/2019.
//  Copyright © 2019 MikeZaslavskiy. All rights reserved.
//

import UIKit

class AppCoordinator: RootCoordinator {
    var tabBarController: UITabBarController?
    var window: UIWindow
    var childCoordinators = [Coordinator]()

    init(window: UIWindow) {
        self.window = window
        tabBarController = UITabBarController()
    }

    func start() {
        guard let tabBarController = self.tabBarController else {
            assertionFailure("Tab bar controller is nil")
            return
        }
        window.rootViewController = tabBarController
        setupChildCoordinators()
    }
    
    private func setupChildCoordinators() {
        let searchCoordinator = buildSearchCoordinator()
        let wishListCoordinator = buildWishListCoordinator()
        
        self.childCoordinators = [searchCoordinator, wishListCoordinator]
        
        tabBarController?.setViewControllers(childCoordinators.map{ $0.navigationController }, animated: false)
    }
}

// MARK: - Child coordinators builder
extension AppCoordinator {
    func  buildWishListCoordinator() -> WishListCoordinator {
        let wishListViewController = WishListViewController()
        let screenTitle = Constants.ScreenTitles.wishList
        let tabBarImage = UIImage(named: Constants.ImageNames.wishList)
        wishListViewController.tabBarItem = UITabBarItem(title: screenTitle, image: tabBarImage, tag: 2)
        let wishListNavigationController = UINavigationController(rootViewController: wishListViewController)
        
        return WishListCoordinator(navigationController: wishListNavigationController)
    }
    
    func buildSearchCoordinator() -> SearchCoordinator {
        let searchViewController = SearchViewController()
        let screenTitle = Constants.ScreenTitles.search
        let tabBarImage = UIImage(named: Constants.ImageNames.search)
        searchViewController.tabBarItem = UITabBarItem(title: screenTitle, image: tabBarImage, tag: 1)
        let searchNavigationController = UINavigationController(rootViewController: searchViewController)
        
        return SearchCoordinator(navigationController: searchNavigationController)
    }
}
