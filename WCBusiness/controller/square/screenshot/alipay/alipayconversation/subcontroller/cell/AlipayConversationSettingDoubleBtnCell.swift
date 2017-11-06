//
//  AlipayConversationSettingDoubleBtnCell.swift
//  WCBusiness
//
//  Created by Ray on 2017/11/3.
//  Copyright © 2017年 LYL. All rights reserved.
//

import UIKit
import SnapKit
class AlipayConversationSettingDoubleBtnCell: UITableViewCell {
    var model:[String: String]!
    var typeStr:String?
    lazy var titleLabel = UILabel()
    lazy var sendBtn = UIButton()
    lazy var receiveBtn = UIButton()
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
        titleLabel.text = "选择类型";
        titleLabel.snp.makeConstraints({(maker) in
            maker.centerY.equalToSuperview()
            maker.left.equalToSuperview().offset(20)
            maker.height.equalTo(20)
        })
        
        receiveBtn = UIButton.init()
        self.addSubview(receiveBtn)
        receiveBtn.backgroundColor = UIColor.clear
        receiveBtn.titleLabel?.font = UIFont.systemFont(ofSize: 13);
        receiveBtn.layer.masksToBounds = true
        receiveBtn.layer.cornerRadius = 15
        receiveBtn.layer.borderWidth = 1
        receiveBtn.layer.borderColor = UIColor.init(hexString: "EFEFF4")?.cgColor
        receiveBtn.setTitle("收红包", for: .normal)
        receiveBtn.setTitleColor(UIColor.gray, for: .normal)
        receiveBtn.titleLabel?.snp.makeConstraints({ (maker) in
            maker.edges.equalToSuperview().inset(UIEdgeInsetsMake(5, 10, 5, 10))
        })
        receiveBtn.snp.makeConstraints { (maker) in
            maker.centerY.equalToSuperview()
            maker.right.equalToSuperview().offset(-10)
        }
        
        sendBtn = UIButton.init()
        self.addSubview(sendBtn)
        sendBtn.titleLabel?.font = UIFont.systemFont(ofSize: 13);
        sendBtn.layer.masksToBounds = true
        sendBtn.layer.cornerRadius = 15
        sendBtn.layer.borderWidth = 1
        sendBtn.setTitle("发红包", for: .normal)
        

        
        sendBtn.titleLabel?.snp.makeConstraints({ (maker) in
            maker.edges.equalToSuperview().inset(UIEdgeInsetsMake(5, 10, 5, 10))
        })
        sendBtn.snp.makeConstraints { (maker) in
            maker.centerY.equalToSuperview()
            maker.right.equalTo(receiveBtn.snp.left).offset(-15)
        }
    }
    func setData(_ model:[String:String]) {
        self.model = model
        self.typeStr = self.model["type"]!
        if self.typeStr == "收红包" {
            self.receiveBtn.backgroundColor = UIColor.init(hexString: "1BA5EA")
            self.receiveBtn.setTitleColor(UIColor.white, for: .normal)
            self.receiveBtn.layer.borderColor = UIColor.clear.cgColor
            self.sendBtn.backgroundColor = UIColor.white
            self.sendBtn.setTitleColor(UIColor.gray, for: .normal)
            self.sendBtn.layer.borderColor = UIColor.gray.cgColor
        } else {
            self.sendBtn.backgroundColor = UIColor.init(hexString: "1BA5EA")
            self.sendBtn.setTitleColor(UIColor.white, for: .normal)
            self.sendBtn.layer.borderColor = UIColor.clear.cgColor
            self.receiveBtn.backgroundColor = UIColor.white
            self.receiveBtn.setTitleColor(UIColor.gray, for: .normal)
            self.receiveBtn.layer.borderColor = UIColor.gray.cgColor
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
