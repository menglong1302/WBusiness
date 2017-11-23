//
//  WXMessageVoiceCell.swift
//  WCBusiness
//
//  Created by YangXL on 2017/11/17.
//  Copyright © 2017年 LYL. All rights reserved.
//

import Foundation
class WXMessageVoiceCell: WXMessageBaseCell {
    
    lazy var  voiceTimeLabel:UILabel = self.makeVoiceTimeLabel()
    lazy var voiceImageView:UIImageView = self.makeVoiceImageView()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func initView() {
        super.initView()
        
        
        [voiceTimeLabel].forEach({
            addSubview($0)
        })
        self.maskBackgroundImageView.addSubview(voiceImageView)
     }
    
    override func updateMessage() {
        super.updateMessage()
        
        self.voiceTimeLabel.text = "\((self.entity?.content)!)\""
        let number = Float((self.entity?.content)!)!
        let width = 60 + (number > 40 ? 1.0 : number / 40.0)  * Float(MAX_MESSAGE_WIDTH - 60)
        
        if isSelf{
            self.voiceImageView.image = UIImage(named:"message_voice_sender_normal")
            self.maskBackgroundImageView.image = UIImage(named:"message_ly_send_bg")?.resizableImage(withCapInsets: UIEdgeInsets(top: 26, left: 6, bottom: 6, right: 27),resizingMode:.stretch)
            self.voiceTimeLabel.snp.remakeConstraints({ (maker) in
                maker.right.equalTo(self.maskBackgroundImageView.snp.left).offset(-5)
                maker.top.equalTo(self.maskBackgroundImageView.snp.centerY).offset(-1)
            })
            self.voiceImageView.snp.remakeConstraints({ (maker) in
                maker.right.equalTo(-13)
                maker.centerY.equalTo(self.avatarButton)
            })
           
        }else{
            self.voiceImageView.image =   UIImage(named:"message_voice_receiver_normal")
            self.maskBackgroundImageView.image = UIImage(named:"message_ly_receive_bg")?.resizableImage(withCapInsets: UIEdgeInsets(top: 26, left: 27, bottom: 6, right: 6),resizingMode:.stretch)
            
            self.voiceTimeLabel.snp.remakeConstraints({ (maker) in
                maker.left.equalTo(self.maskBackgroundImageView.snp.right).offset(5)
                maker.top.equalTo(self.maskBackgroundImageView.snp.centerY).offset(-1)
            })
            self.voiceImageView.snp.remakeConstraints({ (maker) in
                maker.left.equalTo(13)
                maker.centerY.equalTo(self.avatarButton)
            })

        }
        self.maskBackgroundImageView.snp.remakeConstraints({ (maker) in
            if  isSelf {
                maker.right.equalTo(avatarButton.snp.left).offset(-MSGBG_SPACE_X).priority(999)
            }else{
                maker.left.equalTo(avatarButton.snp.right).offset(MSGBG_SPACE_X).priority(999)
                
            }
            maker.top.equalTo(nickName.snp.bottom).offset((self.conversation?.isShowGroupMemberNickName)! ? 0 : -MSGBG_SPACE_Y)
            maker.width.equalTo(width)
            maker.bottom.equalToSuperview().offset(-10)

        })
        
        
        self.layoutIfNeeded()
    }
    
  
    func makeVoiceTimeLabel() -> UILabel {
        let label = UILabel()
        label.textColor = UIColor.gray
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }
    func makeVoiceImageView() -> UIImageView {
        let imageView = UIImageView()
        return imageView
    }
}
