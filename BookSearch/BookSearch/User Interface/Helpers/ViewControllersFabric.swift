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
        let searchViewController = SearchViewController()
        let screenTitle = Constants.ScreenTitles.search
        let tabBarImage = UIImage(named: Constants.ImageNames.search)
        searchViewController.tabBarItem = UITabBarItem(title: screenTitle, image: tabBarImage, tag: 1)
        return searchViewController
    }
    
    static func createWishListViewController() -> WishListViewController {
        let wishListViewController = WishListViewController()
        let screenTitle = Constants.ScreenTitles.wishList
        let tabBarImage = UIImage(named: Constants.ImageNames.wishList)
        wishListViewController.tabBarItem = UITabBarItem(title: screenTitle, image: tabBarImage, tag: 2)
        return wishListViewController
    }
}
