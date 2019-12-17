//
//  AppCoordinator.swift
//  BookSearch
//
//  Created by Zaslavskiy Mike on 17/12/2019.
//  Copyright © 2019 MikeZaslavskiy. All rights reserved.
//

import UIKit

protocol RootCoordinator {
    var childCoordinators: [Coordinator] { get set }
    var tabBarController: UITabBarController? { get set }
    var window: UIWindow { get set }

    func start()
}
