//
//  WXMessageImageCell.swift
//  WCBusiness
//
//  Created by YangXL on 2017/11/17.
//  Copyright © 2017年 LYL. All rights reserved.
//

import Foundation
class WXMessageImageCell: WXMessageBaseCell {
    
    lazy var msgImageView:YLMessageImageView = self.makeMsgImageView()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func initView() {
        super.initView()
        self.addSubview(msgImageView)
    }
    
    func makeMsgImageView() -> YLMessageImageView {
        let msgImage = YLMessageImageView(frame:CGRect.zero)
        
        return msgImage
    }
    override func updateMessage() {
        super.updateMessage()
         self.msgImageView.image = UIImage(contentsOfFile:  (self.entity?.content.localPath())!)
         let size = getSize()
        if isSelf{
            self.msgImageView.maskBackgroundImage(UIImage(named:"message_sender_bg")!)
            
            self.msgImageView.snp.remakeConstraints({ (maker) in
                maker.top.equalTo(self.maskBackgroundImageView)
                maker.right.equalTo(self.maskBackgroundImageView)
                maker.size.equalTo(size)
                maker.bottom.equalToSuperview()
            })
 
 
        }else{
            self.msgImageView.maskBackgroundImage(UIImage(named:"message_receiver_bg")!)
            self.msgImageView.snp.remakeConstraints({ (maker) in
                maker.top.equalTo(self.maskBackgroundImageView)
                maker.left.equalTo(self.maskBackgroundImageView)
                maker.size.equalTo(size)
                maker.bottom.equalToSuperview()

            })
 
        }
        
    }
    
    func getSize() -> CGSize {
         let imageSize = (self.msgImageView.image?.size)!
        
        if __CGSizeEqualToSize(imageSize, CGSize.zero) {
           return CGSize(width: 100, height: 100)
        }
        
        if imageSize.width > imageSize.height{
            var height = MAX_MESSAGE_IMAGE_WIDTH*imageSize.height/imageSize.width
            height = height < MIN_MESSAGE_IMAGE_WIDTH ? MIN_MESSAGE_IMAGE_WIDTH : height
            return CGSize(width:MAX_MESSAGE_IMAGE_WIDTH,height: height)
        }else{
            var width = MAX_MESSAGE_IMAGE_WIDTH * imageSize.width / imageSize.height;
            width = width < MIN_MESSAGE_IMAGE_WIDTH ? MIN_MESSAGE_IMAGE_WIDTH : width;
            return CGSize(width:width, height:MAX_MESSAGE_IMAGE_WIDTH);
        }
        
        
        
    }
    
    
}
