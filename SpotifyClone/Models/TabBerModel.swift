//
//  TabBerModel.swift
//  SpotifyClone
//
//  Created by Silas Da Silva Caxias on 15/08/21.
//

import UIKit

class TabBarModel {
    
    let viewController: UIViewController
    let title: String
    let icon: UIImage?
    let largeTitleDisplayMode: UINavigationItem.LargeTitleDisplayMode = .always
    let prefersLargeTitles: Bool = true
    
    
    init(viewController: UIViewController, title: String, icon: UIImage?) {
        self.viewController = viewController
        self.title = title
        self.icon = icon
    }
    
    func getNavigationController() -> UINavigationController {
        let navigationController = UINavigationController()
        let tabBarItem = UITabBarItem(title: title, image: icon, tag: viewController.hashValue)
        
        viewController.title = title
        viewController.navigationItem.largeTitleDisplayMode = largeTitleDisplayMode
        
        navigationController.viewControllers = [viewController]
        navigationController.navigationBar.tintColor = .label
        navigationController.tabBarItem = tabBarItem
        navigationController.navigationBar.prefersLargeTitles = prefersLargeTitles
        
        return navigationController
    }
}
