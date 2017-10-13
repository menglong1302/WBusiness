//
//  BaseNavigationController.swift
//  WCBusiness
//
//  Created by YangXL on 2017/10/12.
//  Copyright © 2017年 LYL. All rights reserved.
//

import UIKit
import ChameleonFramework
class BaseNavigationController: UINavigationController {
    override func viewDidLoad() {

        super.viewDidLoad()
        self.interactivePopGestureRecognizer!.delegate = nil;
        
        let appearance = UINavigationBar.appearance()
        appearance.isTranslucent = false
        self.setStatusBarStyle(UIStatusBarStyleContrast)

    }
    
 
    
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
//        if self.childViewControllers.count > 0 {
//            viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backBtn)
//            viewController.hidesBottomBarWhenPushed = true
//        }
        super.pushViewController(viewController, animated: animated)
    }
    
    
}
