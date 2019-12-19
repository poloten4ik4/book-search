//
//  UIView+Reusable.swift
//  BookSearch
//
//  Created by Zaslavskiy Mike on 19/12/2019.
//  Copyright © 2019 MikeZaslavskiy. All rights reserved.
//

import UIKit

public protocol ReusableView {
    static var reuseId: String { get }
}

public extension ReusableView where Self: UIView {
    static var reuseId: String {
        return String(describing: self)
    }
}
