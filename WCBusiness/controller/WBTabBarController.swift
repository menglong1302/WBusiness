//
//  WBTabBarController.swift
//  WCBusiness
//
//  Created by YangXL on 2017/10/11.
//  Copyright © 2017年 LYL. All rights reserved.
//

import UIKit
class WBTabBarController: UITabBarController {
    var tabbars = [BaseNavigationController]()
    override func viewDidLoad() {
        super.viewDidLoad()
        addChildViewControllers()
        self.viewControllers = tabbars
        
    }
    
    private func addChildViewControllers(){
        addChildViewController(WBSquareViewController(), title: "广场", imageName: "tabbar_home")
        addChildViewController(WBCommunityViewController(), title: "社区", imageName: "tabbar_gift")
        addChildViewController(WBMyViewController(), title: "我", imageName: "tabbar_me")
    }
    
    private func addChildViewController(_ controller: UIViewController, title:String, imageName:String){
        
        let tabbar = UITabBarItem.init(title: title, image: nil, selectedImage: nil)
        let nav = BaseNavigationController()
        nav.tabBarItem = tabbar
        nav.addChildViewController(controller)
        tabbars.append(nav)
    }
    
  
}
