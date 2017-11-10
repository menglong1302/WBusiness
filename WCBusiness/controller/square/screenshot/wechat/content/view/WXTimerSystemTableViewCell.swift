//
//  WXTimerSystemTableViewCell.swift
//  WCBusiness
//
//  Created by YangXL on 2017/11/10.
//  Copyright © 2017年 LYL. All rights reserved.
//

import Foundation
import ChameleonFramework
class WXTimerSystemTableViewCell: UITableViewCell {
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
        }
        btn24.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(btn12)
            maker.top.equalTo(btn12.snp.bottom).offset(15)
            maker.height.equalTo(35).priority(999)
            maker.bottom.equalToSuperview().offset(-15)
        }
        
    }
    func configer(_ timer:TimeModel)  {
        self.timer = timer
        resetBtn()
    }
    func resetBtn()  {
        if self.timer?.timerType == 0{
            btn12.layer.borderColor = HexColor("ff6633")?.cgColor
            btn12.backgroundColor = HexColor("ff6633")
            btn24.layer.borderColor = UIColor.lightGray.cgColor
            btn12.setTitleColor(UIColor.white, for: .normal)
            btn24.setTitleColor(UIColor.lightGray, for: .normal)
            btn24.backgroundColor = UIColor.white
            
        }else{
            btn24.layer.borderColor = HexColor("ff6633")?.cgColor
            btn24.backgroundColor = HexColor("ff6633")
            
            btn12.layer.borderColor = UIColor.lightGray.cgColor
            btn24.setTitleColor(UIColor.white, for: .normal)
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
