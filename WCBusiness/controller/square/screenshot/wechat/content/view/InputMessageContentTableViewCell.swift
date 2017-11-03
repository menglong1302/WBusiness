//
//  InputMessageContentTableViewCell.swift
//  WCBusiness
//
//  Created by YangXL on 2017/10/30.
//  Copyright © 2017年 LYL. All rights reserved.
//

import Foundation
import YYText
class InputMessageContentTableViewCell: UITableViewCell {
    
    var mapper = [String:UIImage](){
        didSet{
           let  parser = YYTextSimpleEmoticonParser()
            parser.emoticonMapper = mapper;
            textView.textParser = parser
        }
    }
    
    lazy var textView:YYTextView = {
        let textView = YYTextView(frame: CGRect.zero)
        let mod =  YYTextLinePositionSimpleModifier()
        mod.fixedLineHeight = 20
        textView.linePositionModifier = mod
        textView.textContainerInset = UIEdgeInsetsMake(10, 10, 10, 10);
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.placeholderText = "请输入内容"
       textView.keyboardDismissMode = .onDrag
        textView.placeholderFont = UIFont.systemFont(ofSize: 14)
        textView.scrollIndicatorInsets = textView.contentInset;
 
        return textView
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initView()
    }
    
    func initView(){
        addSubview(textView)
        textView.snp.makeConstraints { (maker) in
            maker.height.equalTo(100).priority(999)
            maker.edges.equalToSuperview().inset(UIEdgeInsetsMake(2, 2, 2, 2))
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
