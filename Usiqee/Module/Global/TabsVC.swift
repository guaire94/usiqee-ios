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
}
