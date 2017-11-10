//
//  AlipayConversationSettingTimeButtonCell.swift
//  WCBusiness
//
//  Created by Ray on 2017/11/7.
//  Copyright © 2017年 LYL. All rights reserved.
//

import UIKit
import SnapKit

class AlipayConversationSettingTimeButtonCell: UITableViewCell {
    var model:[String: String]!
    var button:UIButton?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.button = UIButton.init(frame:CGRect.zero)
        self.addSubview(self.button!)
        
        self.button?.layer.masksToBounds = true
        self.button?.layer.cornerRadius = 5
        self.button?.layer.borderWidth = 1
        self.button?.layer.borderColor = UIColor.init(hexString: "EFEFF4")?.cgColor
        self.button?.setTitleColor(UIColor.gray, for: .normal)
        self.button?.titleLabel?.font = UIFont.systemFont(ofSize: 13);
        self.button?.backgroundColor = UIColor.white
        self.button?.snp.makeConstraints({ (maker) in
            maker.center.equalToSuperview()
            maker.top.left.equalToSuperview().offset(10)
            maker.right.bottom.equalToSuperview().offset(-10)
        })
    }
    func setData(_ model:[String:String]) {
        self.model = model
        self.button?.setTitle(self.model["title"]!, for: .normal)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
