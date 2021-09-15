//
//  TabsVC.swift
//  Mooddy
//
//  Created by Quentin Gallois on 06/03/2019.
//  Copyright © 2019 Quentin Gallois. All rights reserved.
//

import UIKit
import Firebase

class TabsVC: UITabBarController {
            
    var allVC: [UIViewController] {
        viewControllers?.compactMap { ($0 as? UINavigationController)?.visibleViewController } ?? []
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let viewControllers = viewControllers, !viewControllers.isEmpty else { return }
        let titles: [String] = [
            L10N.Tabbar.news,
            L10N.Tabbar.calendar,
            L10N.Tabbar.artists,
            L10N.Tabbar.profile
        ]
        for i in 0..<viewControllers.count {
            viewControllers[i].tabBarItem.title = titles[i]
        }
    }
}
