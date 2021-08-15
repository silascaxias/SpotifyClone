//
//  TabBarController.swift
//  SpotifyClone
//
//  Created by Silas Da Silva Caxias on 12/08/21.
//

import UIKit

class TabBarController: UITabBarController {

    private let tabBarModels: [TabBarModel] = [
        TabBarModel(viewController: HomeViewController(), title: "Browse", icon: UIImage(systemName: "house")),
        TabBarModel(viewController: SearchViewController(), title: "Search", icon: UIImage(systemName: "magnifyingglass")),
        TabBarModel(viewController: LibraryViewController(), title: "Library", icon: UIImage(systemName: "music.note.list"))
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UITabBar.appearance().tintColor = UIColor(named: "AppGreen")
        tabBar.unselectedItemTintColor = .label
        setViewControllers((0...tabBarModels.count - 1).map({ tabBarModels[$0].getNavigationController() }), animated: true)
    }
}
