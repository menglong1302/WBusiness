//
//  WXMessageSystemCell.swift
//  WCBusiness
//
//  Created by YangXL on 2017/11/17.
//  Copyright © 2017年 LYL. All rights reserved.
//

import Foundation
import YYText
import ChameleonFramework
import ObjectMapper
class WXMessageSystemCell: UITableViewCell {
    
    lazy var systemLabel:YYLabel = self.makeSystemLabel()
    public var entity:WXContentEntity?
    
    public var conversation:WXConversation?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initView(){
        addSubview(systemLabel)
        self.backgroundColor = UIColor.clear
        systemLabel.snp.remakeConstraints { (maker) in
            maker.centerX.equalToSuperview()
            maker.top.equalToSuperview().offset(5)
            maker.bottom.equalToSuperview().offset(-5)
        }
    }
    
    func makeSystemLabel() -> YYLabel {
        let label = YYLabel()
        label.numberOfLines = 0;
        label.lineBreakMode = .byCharWrapping
        label.font = UIFont.systemFont(ofSize: 13)
        label.preferredMaxLayoutWidth = SCREEN_WIDTH - 60
        let mod =  YYTextLinePositionSimpleModifier()
        mod.fixedLineHeight = 16
        label.linePositionModifier = mod
        label.textColor = UIColor.white
        label.textVerticalAlignment = .center
        label.backgroundColor = HexColor("cecece", 0.9)
        label.layer.cornerRadius = 5
        label.textContainerInset = UIEdgeInsetsMake(0, 5, 2, 5)
        
        return label
    }
    
    func setView() {
        if self.conversation?.backgroundUrl.count != 0{
         self.systemLabel.textColor = UIColor.black
            self.systemLabel.backgroundColor = HexColor("a7b3ca")

        }
        
        
        if self.entity?.contentType == 6{
            let model =  TimeModel(JSONString: (self.entity?.content)!)
            self.systemLabel.text = model?.timer
            
            systemLabel.snp.remakeConstraints { (maker) in
                maker.centerX.equalToSuperview()
                maker.top.equalToSuperview().offset(20)
                maker.height.equalTo(25).priority(999)
                maker.bottom.equalToSuperview()
            }
            self.layoutIfNeeded()
            
        }else if self.entity?.contentType == 7{
            self.systemLabel.text = self.entity?.content
        }else if self.entity?.contentType == 4{
            let model = RedPacketModel(JSONString: (self.entity?.content)!)
            let str = NSMutableAttributedString()
            str.append(NSAttributedString.yy_attachmentString(withEmojiImage: UIImage(named:"xiaobao_icon")!, fontSize: 14)!)
            
            if model?.receiveType == "0"{
                
                 str.append(NSAttributedString(string: " " + (self.entity?.sender?.nickName)! + "领取了您的"))
                str.yy_setColor(UIColor.white, range: NSMakeRange(0, str.length))
                let temp = NSMutableAttributedString(string:"红包")
                temp.yy_setColor(HexColor("f99c3a"), range: NSMakeRange(0, 2))
                str.append(temp)
                self.systemLabel.attributedText = str
            }else{
                
                 str.append(NSAttributedString(string: " 您领取了" + (self.entity?.sender?.nickName)! + "的"))
                str.yy_setColor(UIColor.white, range: NSMakeRange(0, str.length))

                let temp = NSMutableAttributedString(string:"红包")
                temp.yy_setColor(HexColor("f99c3a"), range: NSMakeRange(0, 2))
                str.append(temp)
                self.systemLabel.attributedText = str

            }
            str.yy_setFont(UIFont.systemFont(ofSize: 14), range: NSMakeRange(0, str.length))
            systemLabel.snp.remakeConstraints { (maker) in
                maker.centerX.equalToSuperview()
                maker.top.equalToSuperview().offset(10)
                maker.height.equalTo(25).priority(999)
                maker.bottom.equalToSuperview()
            }
            systemLabel.textContainerInset = UIEdgeInsetsMake(2, 10, 0, 10)
            systemLabel.font = UIFont.systemFont(ofSize: 14)
            self.layoutIfNeeded()
        }
        
    }
}
