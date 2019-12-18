//
//  ControllersFabric.swift
//  BookSearch
//
//  Created by Zaslavskiy Mike on 18/12/2019.
//  Copyright © 2019 MikeZaslavskiy. All rights reserved.
//

import Foundation


class ViewControllersFabric {
    func createBookDetailViewController(_ bookInfo: BookInfo) -> BookDetailViewController {
        // TODO: Provide year of publish
        let bookDetailViewModel = BookDetailViewModel(title: bookInfo.title, yearOfPublish: "1566")
        let bookDetailViewController = BookDetailViewController()
        bookDetailViewController.viewModel = bookDetailViewModel
        bookDetailViewController.title = "Book Details"
        return bookDetailViewController
    }
}
