//
//  BaseViewController.swift
//  WCBusiness
//
//  Created by YangXL on 2017/10/12.
//  Copyright © 2017年 LYL. All rights reserved.
//

import UIKit
import ChameleonFramework
class BaseViewController: UIViewController {
    var isShowBack:Bool? = true
    
    var rightTitle = ""{
        didSet{
             addRightButton()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
        
        navigationController?.navigationBar.barTintColor = HexColor("ff6633")
        
        navigationController?.navigationBar.isTranslucent = false
        self.setStatusBarStyle(UIStatusBarStyleContrast)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated);
        if let isShow =  isShowBack , isShow == true{
            addLeftButtonWithImage()
        }
    }
    
    func addLeftButtonWithImage() {
        
        let btn = UIButton.init(type: .custom)
        btn.setImage(UIImage.init(named: "back")?.withRenderingMode(.alwaysOriginal), for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false;
        btn.addTarget(self, action: #selector(touchLeftBtn), for: .touchUpInside)
        btn.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: -14, bottom: 0, right: 0)
        
        let spaceItem =  UIBarButtonItem.init(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        spaceItem.width = -15;
        navigationItem.leftBarButtonItems = [spaceItem,UIBarButtonItem.init(customView: btn)]
        
    }
    
    func addRightButton()  {
        let btn = UIButton(type: .custom)
        btn.setTitle(rightTitle, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.contentHorizontalAlignment = .right;
        btn.translatesAutoresizingMaskIntoConstraints = false;
        btn.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, -10)
        btn.addTarget(self, action: #selector(rightBtnClick(_:)), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: btn)
        
    }
    @objc  func touchLeftBtn() -> Void {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func rightBtnClick(_ sender:UIButton) -> Void {
        
    }
    
    
    
}
