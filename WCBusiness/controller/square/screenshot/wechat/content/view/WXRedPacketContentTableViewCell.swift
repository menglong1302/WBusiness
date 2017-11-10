
//
//  WXRedPacketContentTableViewCell.swift
//  WCBusiness
//
//  Created by YangXL on 2017/11/9.
//  Copyright © 2017年 LYL. All rights reserved.
//

import Foundation
import YYText
class WXRedPacketContentTableViewCell: UITableViewCell {
    
    lazy var textView:YYTextView = {
        let text = YYTextView(frame: CGRect.zero)
        let mod =  YYTextLinePositionSimpleModifier()
        mod.fixedLineHeight = 24
        text.linePositionModifier = mod
        text.textContainerInset = UIEdgeInsetsMake(2,5,2, 5);
        text.font = UIFont.systemFont(ofSize: 14)
        
        text.placeholderText = "恭喜发财，大吉大利"
        text.keyboardDismissMode = .onDrag
        text.placeholderFont = UIFont.systemFont(ofSize: 14)
        text.scrollIndicatorInsets = text.contentInset;
        text.backgroundColor = UIColor.rgbq(r: 238, g: 236, b: 243, a: 1)
        text.layer.cornerRadius = 3
        text.layer.masksToBounds = true
       return text
    }()
    var model:RedPacketModel?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initView()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("")
    }
    func configer(_ model:RedPacketModel) {
        self.model = model
        self.textView.text = self.model?.content
    }
    func initView()  {
        addSubview(textView)
        textView.snp.makeConstraints { (maker) in
            maker.height.equalTo(35).priority(999)
            maker.edges.equalToSuperview().inset(UIEdgeInsetsMake(10, 15, 10, 15))
        }
        textView.sizeToFit()
    }
    
}
