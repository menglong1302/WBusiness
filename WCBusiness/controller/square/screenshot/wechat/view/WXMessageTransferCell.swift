//
//  WXMessageTransferCell.swift
//  WCBusiness
//
//  Created by YangXL on 2017/11/20.
//  Copyright © 2017年 LYL. All rights reserved.
//

import Foundation
class WXMessageTransferCell: WXMessageBaseCell {
    
    lazy var hintTitle:UILabel = self.makeHintTitle()
    lazy var statusLabel:UILabel = self.makeStatusLabel()
    lazy var categoryLabel:UILabel = self.makeCategoryLabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        [hintTitle,statusLabel,categoryLabel].forEach({
            self.maskBackgroundImageView.addSubview($0)
        })
        self.backgroundColor = UIColor.clear
    }
    
    override func updateMessage() {
        super.updateMessage()
        let model =  TransferAccountsModel(JSONString: (self.entity?.content)!)
        hintTitle.text = "¥" + (model?.transferAmount)!
        if model?.illustration?.count == 0{
            statusLabel.text = "转账给" + (self.entity?.sender?.nickName)!
        }else{
            statusLabel.text = model?.illustration!
        }
        categoryLabel.text = "微信转账"
        if isSelf {
            if (model?.isGetted)!{
                if model?.transferType == 0{ //转账
                    statusLabel.text = "已被领取"
                }else{
                    statusLabel.text = "已收钱"
                }
                self.maskBackgroundImageView.image = UIImage(named:"bg_to_transfer_gray")
            }else{
                self.maskBackgroundImageView.image = UIImage(named:"bg_to_transfer")
 
            }
            
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
            if (model?.isGetted)!{
                
                if model?.transferType == 0{ //转账
                    statusLabel.text = "已被领取"
                }else{
                    statusLabel.text = "已收钱"
                }
                self.maskBackgroundImageView.image = UIImage(named:"bg_from_transfer_gray")
             }else{
                self.maskBackgroundImageView.image = UIImage(named:"bg_from_transfer")
                if model?.illustration?.count == 0{
                    statusLabel.text = "转账给你"
                }else{
                    statusLabel.text = model?.illustration!
                }
            }
            
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
                maker.top.equalTo(hintTitle.snp.bottom).offset(-1)
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
            maker.width.equalTo(235)
            maker.height.equalTo(85)
            maker.bottom.equalToSuperview().offset(-5)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
