//
//  WXMessageBaseCell.swift
//  WCBusiness
//
//  Created by YangXL on 2017/11/16.
//  Copyright © 2017年 LYL. All rights reserved.
//

import Foundation

let AVATAR_SPACE_X = 8.0
let AVATAR_SPACE_Y = 8.0
let AVATAR_WIDTH = 40.0
let NAME_HEIGHT = 14.0
let NAME_SPACE_X = 10.0
let NAME_SPACE_Y = 1.0
let MSGBG_SPACE_X = 5.0
let MSGBG_SPACE_Y = 1.0
 class WXMessageBaseCell: UITableViewCell {
    
    lazy var avatarButton = self.makeAvatarButtion()
    
    lazy var nickName = self.makeLabel()
    
    lazy var maskBackgroundImageView = self.makeMaskBackgroundImageView()
    
    public var entity:WXContentEntity?
    
    public var conversation:WXConversation?
   
    var isSelf:Bool{
        get{
            if entity?.sender?.id == conversation?.sender?.id{
                return true
            }else{
                return false
            }
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func initView() {
        [avatarButton,nickName,maskBackgroundImageView].forEach {
            addSubview($0)
        }
        avatarButton.snp.makeConstraints { (maker) in
            maker.right.equalTo(self).offset(-AVATAR_SPACE_X)
            maker.width.height.equalTo(AVATAR_WIDTH)
            maker.top.equalTo(AVATAR_SPACE_Y)
        }
        nickName.snp.makeConstraints { (maker) in
            maker.top.equalTo(avatarButton).offset(-NAME_SPACE_Y)
            maker.right.equalTo(avatarButton.snp.left).offset(-NAME_SPACE_X)
        }
        maskBackgroundImageView.snp.makeConstraints { (maker) in
            maker.right.equalTo(avatarButton.snp.left).offset(-MSGBG_SPACE_X)
            maker.top.equalTo(nickName.snp.bottom).offset(-MSGBG_SPACE_Y)
        }
    }
    
    func updateMessage() {
        if (self.entity?.sender?.isDiskImage)! {
            avatarButton.setImage(UIImage(contentsOfFile: (self.entity?.sender?.imageUrl.localPath())!), for: .normal)
        }else{
            avatarButton.setImage(UIImage(named: (self.entity?.sender?.imageName)!), for: .normal)
        }
        nickName.text = self.entity?.sender?.nickName
        
        avatarButton.snp.remakeConstraints { (maker) in
            maker.width.height.equalTo(AVATAR_WIDTH);
            maker.top.equalTo(AVATAR_SPACE_Y)
            if isSelf{
                maker.right.equalTo(self).offset(-AVATAR_SPACE_X)
            }else{
                maker.left.equalTo(self).offset(AVATAR_SPACE_X)
            }
        }
        
        nickName.snp.remakeConstraints { (maker) in
            maker.top.equalTo(avatarButton).offset(-NAME_SPACE_Y)
            if isSelf{
                maker.right.equalTo(avatarButton.snp.left).offset(-NAME_SPACE_X)
            }else{
                maker.left.equalTo(avatarButton.snp.right).offset(NAME_SPACE_X)
            }
            maker.height.equalTo((self.conversation?.isShowGroupMemberNickName)! ? NAME_HEIGHT:0)
        }
        maskBackgroundImageView.snp.remakeConstraints { (maker) in
            if  isSelf {
                maker.right.equalTo(avatarButton.snp.left).offset(-MSGBG_SPACE_X).priority(999)
            }else{
                maker.left.equalTo(avatarButton.snp.right).offset(MSGBG_SPACE_X).priority(999)
                
            }
            maker.top.equalTo(nickName.snp.bottom).offset((self.conversation?.isShowGroupMemberNickName)! ? -1 : -MSGBG_SPACE_Y)
        }
        
        nickName.isHidden = !(self.conversation?.isShowGroupMemberNickName)!
        
    }
    
    func makeAvatarButtion() -> UIButton {
        let btn = UIButton()
        btn.layer.masksToBounds = true
        
        return btn
    }
    func makeLabel() -> UILabel {
        let label = UILabel()
        label.textColor = UIColor.gray
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }
    func makeMaskBackgroundImageView() -> UIImageView {
        let imageView = UIImageView()
        return imageView
    }
}
