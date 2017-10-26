//
//  ChatSettingTableViewCell.swift
//  WCBusiness
//
//  Created by YangXL on 2017/10/26.
//  Copyright © 2017年 LYL. All rights reserved.
//

import Foundation
class ChatSettingTableViewCell: UITableViewCell {
    
    lazy var hintLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.flatBlack
        return  label
    }()
    
    lazy var numLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.flatBlack
        return  label
    }()
    lazy var swichBar:UISwitch = {
        let swichBar = UISwitch(frame: CGRect.zero)
        
        return swichBar
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initView() {
        [hintLabel,numLabel,swichBar].forEach { (view) in
            addSubview(view)
        }
        
        hintLabel.snp.makeConstraints { (maker) in
            maker.left.equalToSuperview().offset(15)
            maker.centerY.equalToSuperview()
        }
        numLabel.snp.makeConstraints { (maker) in
            maker.right.equalToSuperview().offset(-30)
            maker.centerY.equalToSuperview()
        }
        swichBar.snp.makeConstraints { (maker) in
            maker.right.equalToSuperview().offset(-30)
            maker.centerY.equalToSuperview()
            maker.width.equalTo(40)
            maker.height.equalTo(30)
        }
    }
}
