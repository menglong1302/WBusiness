//
//  WXMessageRedPacketCell.swift
//  WCBusiness
//
//  Created by YangXL on 2017/11/20.
//  Copyright © 2017年 LYL. All rights reserved.
//

import Foundation
import ChameleonFramework
class WXMessageRedPacketCell: WXMessageBaseCell {
    
    lazy var hintTitle:UILabel = self.makeHintTitle()
    lazy var statusLabel:UILabel = self.makeStatusLabel()
    lazy var categoryLabel:UILabel = self.makeCategoryLabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func initView() {
        super.initView()
        [hintTitle,statusLabel,categoryLabel].forEach({
            self.maskBackgroundImageView.addSubview($0)
        })
        
    }
    
    func setView(){
        let model =  RedPacketModel(JSONString: (self.entity?.content)!)
        hintTitle.text = model?.content
        statusLabel.text = "领取红包"
    }
    override func updateMessage() {
        super.updateMessage()
        categoryLabel.text = "微信红包"
        if isSelf {
            self.maskBackgroundImageView.image = UIImage(named:"bg_from_hongbao")
            
            categoryLabel.snp.remakeConstraints({ (maker) in
                maker.left.equalTo(10)
                maker.bottom.equalToSuperview().offset(-1)
                maker.height.equalTo(20)
            })
            
            hintTitle.snp.remakeConstraints({ (maker) in
                maker.left.equalTo(60)
                maker.height.equalTo(20)
                maker.right.equalToSuperview().offset(-10)
                maker.top.equalTo(15)
            })
            statusLabel.snp.remakeConstraints({ (maker) in
                maker.top.equalTo(hintTitle.snp.bottom).offset(-1)
                maker.height.equalTo(20)
                maker.left.equalTo(hintTitle)
            })
            
        }else{
            self.maskBackgroundImageView.image = UIImage(named:"bg_to_hongbao")
            
            categoryLabel.snp.remakeConstraints({ (maker) in
                maker.left.equalTo(15)
                maker.bottom.equalToSuperview().offset(-1)
                maker.height.equalTo(20)
            })
            
            hintTitle.snp.remakeConstraints({ (maker) in
                maker.left.equalTo(65)
                maker.height.equalTo(20)
                maker.right.equalToSuperview().offset(-10)
                maker.top.equalTo(15)
            })
            statusLabel.snp.remakeConstraints({ (maker) in
                maker.top.equalTo(hintTitle.snp.bottom)
                maker.height.equalTo(20)
                maker.left.equalTo(hintTitle)
            })
        }
        
        maskBackgroundImageView.snp.remakeConstraints { (maker) in
            if  isSelf {
                maker.right.equalTo(avatarButton.snp.left).offset(-MSGBG_SPACE_X).priority(999)
            }else{
                maker.left.equalTo(avatarButton.snp.right).offset(MSGBG_SPACE_X).priority(999)
                
            }
            maker.top.equalTo(nickName.snp.bottom).offset((self.conversation?.isShowGroupMemberNickName)! ? 0 : -MSGBG_SPACE_Y)
            maker.width.equalTo(MAX_MESSAGE_WIDTH)
            maker.height.equalTo(MIN_MESSAGE_IMAGE_WIDTH)
            maker.bottom.equalToSuperview().offset(-5)
        }
        
    }
    func makeHintTitle() -> UILabel {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.white
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        return label
    }
    
    func makeStatusLabel() -> UILabel {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.white
        label.backgroundColor = UIColor.clear
        
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        return label
    }
    
    func makeCategoryLabel() -> UILabel {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10)
        label.backgroundColor = UIColor.white
        label.textColor = UIColor.gray
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        return label
    }
    
    
}
