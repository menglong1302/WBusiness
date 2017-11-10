//
//  WXTimerSystemTableViewCell.swift
//  WCBusiness
//
//  Created by YangXL on 2017/11/10.
//  Copyright © 2017年 LYL. All rights reserved.
//

import Foundation
import ChameleonFramework
import YYText
class WXPromptTableViewCell: UITableViewCell {
   
    lazy var textView:YYTextView = {
        let textView = YYTextView(frame: CGRect.zero)
        let mod =  YYTextLinePositionSimpleModifier()
        mod.fixedLineHeight = 24
        textView.linePositionModifier = mod
        textView.textContainerInset = UIEdgeInsetsMake(2, 5, 2, 5);
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.placeholderText = "请输入系统提示"
        textView.keyboardDismissMode = .onDrag
        textView.placeholderFont = UIFont.systemFont(ofSize: 14)
        textView.scrollIndicatorInsets = textView.contentInset;
        return textView
    }()
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initView()  {
        addSubview(textView)
        textView.snp.makeConstraints { (maker) in
            maker.height.equalTo(100).priority(999)
            maker.edges.equalToSuperview().inset(UIEdgeInsetsMake(2, 2, 2, 2))
        }
        textView.sizeToFit()
        
    }
    
}

