//
//  AlipayConversationSettingTextFieldCell.swift
//  WCBusiness
//
//  Created by Ray on 2017/11/3.
//  Copyright © 2017年 LYL. All rights reserved.
//

import UIKit
import SnapKit

class AlipayConversationSettingTextFieldCell: UITableViewCell {
    var textField:UITextField?
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.textField = UITextField.init(frame:CGRect.zero)
        self.addSubview(self.textField!)
        self.textField?.placeholder = "恭喜发财，大吉大利！"
        self.textField?.borderStyle = UITextBorderStyle.roundedRect
        self.textField?.font = UIFont.systemFont(ofSize: 14)
        self.textField?.returnKeyType = UIReturnKeyType.done
        self.textField?.backgroundColor = UIColor.init(hexString: "EFEFF4")
        self.textField?.snp.makeConstraints({ (maker) in
            maker.center.equalToSuperview()
            maker.top.left.equalToSuperview().offset(10)
            maker.right.bottom.equalToSuperview().offset(-10)
        })
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
