//
//  WXConversationTableViewCell.swift
//  WCBusiness
//
//  Created by YangXL on 2017/11/3.
//  Copyright © 2017年 LYL. All rights reserved.
//

import Foundation
import YYText
class WXConversationTableViewCell: UITableViewCell {
    lazy var contentLabel:YYLabel = {
        let label = YYLabel()
        label.textVerticalAlignment = .center
        label.numberOfLines = 1;
        label.lineBreakMode = .byTruncatingTail
        label.font = UIFont.systemFont(ofSize: 15)
        let mod =  YYTextLinePositionSimpleModifier()
        mod.fixedLineHeight = 20
        label.linePositionModifier = mod
        
        var emojiMapper = [String:UIImage]()
        
        for index in 1...114{
            let model = EmojiModel()
            model.name = "Expression_"+String(index)+".png"
            model.mapperName = ":100\(index):"
            emojiMapper[model.mapperName!] = model.image
        }
        let parser = YYTextSimpleEmoticonParser()
        parser.emoticonMapper = emojiMapper;
        label.textParser = parser
        return label
    }()
    lazy var portraitIcon:UIImageView = {
        let view = UIImageView()
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFill
        return view
    }()
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initView()
    }
    func initView()  {
        addSubview(contentLabel)
        addSubview(portraitIcon)
        
        portraitIcon.snp.makeConstraints { (maker) in
            maker.height.width.equalTo(35)
            maker.centerY.equalToSuperview()
            maker.left.equalTo(15)
        }
        contentLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(portraitIcon.snp.right).offset(10)
            maker.right.equalToSuperview().offset(-10)
            maker.centerY.equalToSuperview()
        }
    }
    
    func configer(_ model:WXContentEntity){
        portraitIcon.image = model.sender?.image
        var  content:String?
        switch model.contentType{
        case 0:
            content = "[文本] "+model.content
            break
        case 1:
             content = "[图片]"
            break
        case 2:
             content = "[语音]"
            break
        case 3:
             content = "[红包]"
            break
        case 4:
             content = "[转账]"
            break
        case 5:
             content = "[时间]"
            break
        case 6:
             content = "[系统提示]"
            break
        case 7:
             content = "[收款]"
            break
        default:
             content = "[文本]"
            break
        }
        let content1 = NSMutableAttributedString(string: content!)
        content1.yy_font = UIFont.systemFont(ofSize: 15)
      contentLabel.attributedText = content1
        contentLabel.sizeToFit()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
