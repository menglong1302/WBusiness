//
//  AlipayConversationSettingSwitchCell.swift
//  WCBusiness
//
//  Created by Ray on 2017/10/19.
//  Copyright © 2017年 LYL. All rights reserved.
//

import UIKit
import SnapKit

class AlipayConversationSettingSwitchCell: UITableViewCell {
    var model:[String: String]!
    lazy var titleLabel = UILabel()
    lazy var swichBtn = UISwitch()
    var switchValstring = ""
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style , reuseIdentifier: reuseIdentifier)
        initView ()
    }
    func initView (){
        titleLabel = UILabel.init()
        self.addSubview(titleLabel)
        titleLabel.textColor = UIColor.black
        titleLabel.textAlignment = .left
        titleLabel.font = UIFont.systemFont(ofSize: 15);
        titleLabel.snp.makeConstraints({(maker) in
            maker.top.bottom.equalToSuperview()
            maker.left.equalToSuperview().offset(20)
            maker.height.equalTo(20)
        })
        swichBtn = UISwitch.init()
        self.addSubview(swichBtn)
        swichBtn.isOn = true
        swichBtn.contentVerticalAlignment = .center
        swichBtn.addTarget(self, action:#selector(swithClick(_:)), for:.valueChanged)
        swichBtn.snp.makeConstraints({(maker) in
            maker.top.equalToSuperview().offset(10)
            maker.right.equalToSuperview().offset(-10)
            maker.width.equalTo(60)
            maker.height.equalTo(30)
        })
    }
    func setData(_ model:[String:String]) {
        self.model = model
        titleLabel.text = self.model["title"]!
    }
    //switch的点击事件
    func swithClick(_ sender : UISwitch) {
        
        if (sender.isOn == true) {
            switchValstring = "YES"
            print("YES")
        }else{
            switchValstring = "NO"
            print("NO")
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
