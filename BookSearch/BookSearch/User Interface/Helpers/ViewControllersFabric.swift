//
//  ControllersFabric.swift
//  BookSearch
//
//  Created by Zaslavskiy Mike on 18/12/2019.
//  Copyright © 2019 MikeZaslavskiy. All rights reserved.
//

import UIKit

class ViewControllersFabric {
    static func createBookDetailViewController(_ bookInfo: BookInfo) -> BookDetailViewController {
        let bookDetailViewModel = BookDetailViewModel(bookInfo: bookInfo)
        let bookDetailViewController = BookDetailViewController()
        bookDetailViewController.viewModel = bookDetailViewModel
        bookDetailViewController.title = "Book Details"
        return bookDetailViewController
    }
    
    static func createSearchViewController() -> SearchViewController {
        let viewModel = SearchViewModel()
        let viewController = SearchViewController()
        viewController.viewModel = viewModel
        let screenTitle = PublicConstants.ScreenTitles.search
        let tabBarImage = UIImage(named: PublicConstants.ImageNames.search)
        viewController.tabBarItem = UITabBarItem(title: screenTitle, image: tabBarImage, tag: 0)
        return viewController
    }
    
    static func createWishListViewController() -> WishListViewController {
        let viewModel = WishListViewModel()
        let viewController = WishListViewController()
        viewController.viewModel = viewModel
        let screenTitle = PublicConstants.ScreenTitles.wishList
        let tabBarImage = UIImage(named: PublicConstants.ImageNames.wishList)
        viewController.tabBarItem = UITabBarItem(title: screenTitle, image: tabBarImage, tag: 1)
        return viewController
    }
}
