//
//  WXMessageTextCell.swift
//  WCBusiness
//
//  Created by YangXL on 2017/11/16.
//  Copyright © 2017年 LYL. All rights reserved.
//

import Foundation
import YYText
public let     MSG_SPACE_TOP    =   14
public let     MSG_SPACE_BTM    =   20
public let     MSG_SPACE_LEFT   =   15
public let     MSG_SPACE_RIGHT  =   15


class WXMessageTextCell: WXMessageBaseCell {
    
    lazy var messageLabel:YYLabel = self.makeMessageLabel()
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func initView() {
        super.initView()
        addSubview(messageLabel)
    }
    
    override func updateMessage() {
        super.updateMessage()
        
        let content = NSMutableAttributedString(string: (self.entity?.content)!)
        content.yy_font = UIFont.systemFont(ofSize: 16)
        content.yy_lineSpacing = 0.0
        content.yy_maximumLineHeight = 18
         content.yy_lineBreakMode = .byCharWrapping
        
        let container = YYTextContainer(size: CGSize(width: MAX_MESSAGE_WIDTH, height: CGFloat.greatestFiniteMagnitude), insets: UIEdgeInsets.zero)
        let layout = YYTextLayout(container: container, text: content)
        
        messageLabel.textLayout = layout
 
        
        messageLabel.attributedText = content
        messageLabel.sizeToFit()
           if isSelf {
            
            self.maskBackgroundImageView.image = UIImage(named:"message_ly_send_bg")?.resizableImage(withCapInsets: UIEdgeInsets(top: 26, left: 6, bottom: 6, right: 27),resizingMode:.stretch)
            self.messageLabel.snp.remakeConstraints({ (maker) in
                maker.right.equalTo(self.maskBackgroundImageView).offset(-MSG_SPACE_RIGHT);
                maker.top.equalTo(self.maskBackgroundImageView).offset(10)
                maker.width.lessThanOrEqualTo(MAX_MESSAGE_WIDTH)
                maker.bottom.equalToSuperview().offset(-15)
 
            })
            
            self.maskBackgroundImageView.snp.remakeConstraints({ (maker) in
                maker.left.equalTo(self.messageLabel).offset(-MSG_SPACE_LEFT)
                maker.bottom.equalTo(self.messageLabel.snp.bottom).offset(10)
                  maker.right.equalTo(avatarButton.snp.left).offset(-MSGBG_SPACE_X)
                maker.top.equalTo(nickName.snp.bottom).offset((self.conversation?.isShowGroupMemberNickName)! ? 0 : -MSGBG_SPACE_Y)
            })
 
            
        }else{
            self.maskBackgroundImageView.image = UIImage(named:"message_ly_receive_bg")?.resizableImage(withCapInsets: UIEdgeInsets(top: 26, left: 27, bottom: 6, right: 6),resizingMode:.stretch)
            
            self.messageLabel.snp.remakeConstraints({ (maker) in
                maker.left.equalTo(self.maskBackgroundImageView).offset(MSG_SPACE_RIGHT)
                maker.top.equalTo(self.maskBackgroundImageView).offset(MSG_SPACE_TOP)
                maker.bottom.equalToSuperview().offset(-15)
                maker.width.lessThanOrEqualTo(MAX_MESSAGE_WIDTH)

                

            })
            self.maskBackgroundImageView.snp.remakeConstraints({ (maker) in
                maker.right.equalTo(self.messageLabel).offset(MSG_SPACE_LEFT)
                maker.bottom.equalTo(self.messageLabel.snp.bottom).offset(10)
                  maker.left.equalTo(avatarButton.snp.right).offset(MSGBG_SPACE_X).priority(999)
          maker.top.equalTo(nickName.snp.bottom).offset((self.conversation?.isShowGroupMemberNickName)! ? 0 : -MSGBG_SPACE_Y)
            })
 
            
        }
        self.layoutIfNeeded()

    }
    
    
    func makeMessageLabel() -> YYLabel {
        let label = YYLabel()
        label.textVerticalAlignment = .center
        label.numberOfLines = 0;
        label.lineBreakMode = .byCharWrapping
        label.font = UIFont.systemFont(ofSize: 16)
        label.preferredMaxLayoutWidth = MAX_MESSAGE_WIDTH
        let mod =  YYTextLinePositionSimpleModifier()
        mod.fixedLineHeight = 18
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
    }
}
