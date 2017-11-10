//
//  WXRedPacketTableViewCell.swift
//  WCBusiness
//
//  Created by YangXL on 2017/11/9.
//  Copyright © 2017年 LYL. All rights reserved.
//

import Foundation
import ChameleonFramework
typealias RedPacketBlock = () -> Void
class WXRedPacketTypeTableViewCell: UITableViewCell {
    
    lazy var hintLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.flatBlack
        return  label
    }()
    
    lazy var sendRed:UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("发红包", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.layer.cornerRadius = 15.0
        btn.layer.masksToBounds = true
        btn.layer.borderColor = UIColor.lightGray.cgColor
        btn.layer.borderWidth = 0.5
        btn.setTitleColor(UIColor.flatGray, for: .normal)
        btn.contentEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 20)
        btn.addTarget(self, action: #selector(sendRedBtnClick(_:)), for: .touchUpInside)
        return btn
    }()
    lazy var receiveRed:UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("收红包", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.layer.cornerRadius = 15.0
        btn.layer.masksToBounds = true
        btn.layer.borderColor = UIColor.lightGray.cgColor
        btn.layer.borderWidth = 0.5
        btn.setTitleColor(UIColor.flatGray, for: .normal)
        btn.contentEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 20)
        btn.addTarget(self, action: #selector(receiveRedBtnClick(_:)), for: .touchUpInside)
        
        return btn
    }()
    var block:RedPacketBlock?
    var model:RedPacketModel?
    var type:Int = 0  //0: 红包类型  1：收红包类型
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initView()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("")
    }
    func configer(_ model:RedPacketModel) {
        self.model = model
        resetBtn()
    }
    func initView()  {
        [hintLabel,sendRed,receiveRed].forEach {
            addSubview($0)
        }
        hintLabel.snp.makeConstraints { (maker) in
            maker.left.equalToSuperview().offset(15)
            maker.centerY.equalToSuperview()
        }
        receiveRed.snp.makeConstraints { (maker) in
            maker.right.equalToSuperview().offset(-10)
            maker.centerY.equalToSuperview()
            maker.height.equalTo(30)
            
        }
        sendRed.snp.makeConstraints { (maker) in
            maker.right.equalTo(receiveRed.snp.left).offset(-10)
            maker.centerY.equalToSuperview()
            maker.height.equalTo(30)
            
        }
    }
    func resetBtn(){
        if self.type == 0{
            if self.model?.packetType == "0"{
                sendRed.layer.borderColor = HexColor("ff6633")?.cgColor
                sendRed.backgroundColor = HexColor("ff6633")
                receiveRed.layer.borderColor = UIColor.lightGray.cgColor
                sendRed.setTitleColor(UIColor.white, for: .normal)
                receiveRed.setTitleColor(UIColor.lightGray, for: .normal)
                receiveRed.backgroundColor = UIColor.white
                
            }else{
                receiveRed.layer.borderColor = HexColor("ff6633")?.cgColor
                receiveRed.backgroundColor = HexColor("ff6633")
                
                sendRed.layer.borderColor = UIColor.lightGray.cgColor
                receiveRed.setTitleColor(UIColor.white, for: .normal)
                sendRed.setTitleColor(UIColor.lightGray, for: .normal)
                sendRed.backgroundColor = UIColor.white
                
            }
        }else if self.type == 1{
            if self.model?.receiveType == "0"{
                sendRed.layer.borderColor = HexColor("ff6633")?.cgColor
                sendRed.backgroundColor = HexColor("ff6633")
                receiveRed.layer.borderColor = UIColor.lightGray.cgColor
                sendRed.setTitleColor(UIColor.white, for: .normal)
                receiveRed.setTitleColor(UIColor.lightGray, for: .normal)
                receiveRed.backgroundColor = UIColor.white
                
            }else{
                receiveRed.layer.borderColor = HexColor("ff6633")?.cgColor
                receiveRed.backgroundColor = HexColor("ff6633")
                
                sendRed.layer.borderColor = UIColor.lightGray.cgColor
                receiveRed.setTitleColor(UIColor.white, for: .normal)
                sendRed.setTitleColor(UIColor.lightGray, for: .normal)
                sendRed.backgroundColor = UIColor.white
                
            }
        }
        
    }
    @objc func sendRedBtnClick(_ btn:UIButton){
        if self.type == 0 {
            self.model?.packetType = "0"

        }else{
            self.model?.receiveType = "0"
        }
         if self.block != nil {
            self.block!()
        }
    }
    @objc func receiveRedBtnClick(_ btn:UIButton){
        if self.type == 0 {
            self.model?.packetType = "1"
            
        }else{
            self.model?.receiveType = "1"
        }
        if self.block != nil {
            self.block!()
        }
    }
}







