//
//  WXChatViewController.swift
//  WCBusiness
//
//  Created by YangXL on 2017/11/14.
//  Copyright © 2017年 LYL. All rights reserved.
//

import Foundation
import ChameleonFramework
class WXChatViewController: UIViewController {
    
    
    var conversationType:ConversationType?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = HexColor("EBEBEB")
        
        self.navigationItem.title = "微信"
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        let container = UIControl()
        container.backgroundColor = UIColor.clear
        container.addTarget(self, action: #selector(leftBtnClick), for: .touchUpInside)
        let imageView:UIImageView = {
            let view = UIImageView()
            view.image = UIImage(named:"wxback")
            view.contentMode = .scaleAspectFill
            return view
        }()
        let label:UILabel = {
            let label = UILabel()
            label.text = "微信"
            label.font = UIFont.systemFont(ofSize: 15.8)
            label.textColor = UIColor.white
            return label
        }()
        [imageView,label].forEach {
            container.addSubview($0)
        }
        let leftItem =  UIBarButtonItem(customView: container)
        container.snp.makeConstraints { (maker) in
            maker.width.equalTo(40)
            maker.height.equalTo(35)
        }
        imageView.snp.makeConstraints { (maker) in
            maker.left.equalToSuperview().offset(-5)
            maker.width.equalTo(15)
            maker.height.equalTo(30)
            maker.centerY.equalToSuperview()
        }
        label.snp.makeConstraints { (maker) in
            maker.centerY.equalToSuperview().offset(0.8)
            maker.left.equalTo(imageView.snp.right).offset(-0.3)
        }
         self.navigationItem.leftBarButtonItem = leftItem
        
        let titleView:UILabel = {
           let label = UILabel()
            label.text = "IT部门(11)"
            label.textColor = UIColor.white
            label.font = UIFont.boldSystemFont(ofSize: 18)
            return label
        }()
        self.navigationItem.titleView = titleView
        

        let rightBtn:UIButton = {
           let btn = UIButton(type: .custom)
            btn.setImage(UIImage(named: "barbuttonicon_InfoMulti"), for: .normal)
            return btn
        }()
        rightBtn.imageView?.snp.makeConstraints({ (maker) in
            maker.right.equalToSuperview().offset(5)
            maker.width.height.equalTo(30)
        })
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightBtn)

        
    }
    
    @objc func leftBtnClick(){
        self.dismiss(animated: true, completion: nil)
    }
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
}
