//
//  WXBaseNavigationViewController.swift
//  WCBusiness
//
//  Created by YangXL on 2017/11/14.
//  Copyright © 2017年 LYL. All rights reserved.
//

import Foundation
import ChameleonFramework
class WXBaseNavigationViewController: UINavigationController {
    lazy var blurView:UIView = {
        let view = UIView()
        view.frame = CGRect(x: 0, y: -20, width: SCREEN_WIDTH, height: 64)
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: 0, y:0, width: SCREEN_WIDTH, height: 64)
        gradientLayer.colors = [HexColor("040012", 1)!.cgColor,HexColor("040012", 0.23)!.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1.0)
        view.layer.addSublayer(gradientLayer)
        view.isUserInteractionEnabled = true
        view.alpha = 0.3
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
        navigationBar.barStyle = .black
        navigationBar.barTintColor = UIColor.rgbq(r: 20, g: 20, b: 20, a: 0.1)
        navigationBar.isTranslucent = true

       
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        for view in (navigationBar.subviews){
            if  NSStringFromClass(view.classForCoder) == "_UINavigationBarContentView"{
                view.insertSubview(self.blurView, at: 0)
            }
        }
        
        
    }
   
}
