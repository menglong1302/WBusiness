//
//  GroupConversationSettingViewController.swift
//  WCBusiness
//
//  Created by YangXL on 2017/10/25.
//  Copyright © 2017年 LYL. All rights reserved.
//

import Foundation
class GroupConversationSettingViewController: BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    func initView()  {
        view.backgroundColor = UIColor.rgbq(r: 238, g: 236, b: 243, a: 1)
        navigationItem.title = "群聊设置"
    }
}
