//
//  AlipayConversationSettingTimeButtonCell.swift
//  WCBusiness
//
//  Created by Ray on 2017/11/7.
//  Copyright © 2017年 LYL. All rights reserved.
//

import Foundation
import ChameleonFramework
class AlipayConversationSettingTimeButtonCell: UITableViewCell {
    var timer:TimeModel?
    var block:RedPacketBlock?
    lazy var btn12:UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("12小时制", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.layer.cornerRadius = 5.0
        btn.layer.masksToBounds = true
        btn.layer.borderColor = UIColor.lightGray.cgColor
        btn.layer.borderWidth = 0.5
        btn.setTitleColor(UIColor.flatGray, for: .normal)
        btn.contentEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 20)
        btn.addTarget(self, action: #selector(btn12Click(_:)), for: .touchUpInside)
        return btn
    }()
    lazy var btn24:UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("24小时制", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.layer.cornerRadius = 5.0
        btn.layer.masksToBounds = true
        btn.layer.borderColor = UIColor.lightGray.cgColor
        btn.layer.borderWidth = 0.5
        btn.setTitleColor(UIColor.flatGray, for: .normal)
        btn.contentEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 20)
        btn.addTarget(self, action: #selector(btn24Click(_:)), for: .touchUpInside)
        return btn
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initView()  {
        [btn12,btn24].forEach {
            addSubview($0)
        }
        btn12.snp.makeConstraints { (maker) in
            maker.left.equalToSuperview().offset(15)
            maker.right.equalToSuperview().offset(-15)
            maker.top.equalToSuperview().offset(10)
            maker.height.equalTo(35)
//            maker.center.equalToSuperview()
//            maker.top.left.equalToSuperview().offset(10)
//            maker.right.bottom.equalToSuperview().offset(-10)
        }
        btn24.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(btn12)
            maker.top.equalTo(btn12.snp.bottom).offset(15)
            maker.height.equalTo(35).priority(999)
            maker.bottom.equalToSuperview().offset(-15)
//            maker.center.equalToSuperview()
//            maker.top.left.equalToSuperview().offset(10)
//            maker.right.bottom.equalToSuperview().offset(-10)
        }
        
    }
    func configer(_ timer:TimeModel)  {
        self.timer = timer
        resetBtn()
    }
    func resetBtn()  {
        if self.timer?.timerType == 0{
            btn12.layer.borderColor = HexColor("1BA5EA")?.cgColor
            btn12.backgroundColor = HexColor("1BA5EA")
            btn12.setTitleColor(UIColor.white, for: .normal)
            
            btn24.layer.borderColor = UIColor.lightGray.cgColor
            btn24.setTitleColor(UIColor.lightGray, for: .normal)
            btn24.backgroundColor = UIColor.white
            
        }else{
            btn24.layer.borderColor = HexColor("1BA5EA")?.cgColor
            btn24.backgroundColor = HexColor("1BA5EA")
            btn24.setTitleColor(UIColor.white, for: .normal)

            btn12.layer.borderColor = UIColor.lightGray.cgColor
            btn12.setTitleColor(UIColor.lightGray, for: .normal)
            btn12.backgroundColor = UIColor.white
            
        }
    }
    @objc func btn12Click(_ btn:UIButton){
        self.timer?.timerType = 0
        let timeInterval:TimeInterval = TimeInterval((self.timer?.time)!)
        let date = Date(timeIntervalSince1970: timeInterval)
        self.timer?.timer = date.getStringDateFrom12()
        
        
        if self.block != nil {
            self.block!()
        }
    }
    @objc func btn24Click(_ btn:UIButton){
        self.timer?.timerType = 1
        let timeInterval:TimeInterval = TimeInterval((self.timer?.time)!)
        let date = Date(timeIntervalSince1970: timeInterval)
        self.timer?.timer = date.getStringDateFrom24()
        if self.block != nil {
            self.block!()
        }
    }
}

//import UIKit
//import SnapKit
//
//class AlipayConversationSettingTimeButtonCell: UITableViewCell {
//    var model:[String: String]!
//    var button:UIButton?
//    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        self.button = UIButton.init(frame:CGRect.zero)
//        self.addSubview(self.button!)
//        self.button?.layer.masksToBounds = true
//        self.button?.layer.cornerRadius = 5
//        self.button?.layer.borderWidth = 1
//        self.button?.layer.borderColor = UIColor.init(hexString: "EFEFF4")?.cgColor
//        self.button?.setTitleColor(UIColor.gray, for: .normal)
//        self.button?.titleLabel?.font = UIFont.systemFont(ofSize: 13);
//        self.button?.backgroundColor = UIColor.white
//        self.button?.snp.makeConstraints({ (maker) in
//            maker.center.equalToSuperview()
//            maker.top.left.equalToSuperview().offset(10)
//            maker.right.bottom.equalToSuperview().offset(-10)
//        })
//    }
//    func setData(_ model:[String:String]) {
//        self.model = model
//        self.button?.setTitle(self.model["title"]!, for: .normal)
//    }
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//}

