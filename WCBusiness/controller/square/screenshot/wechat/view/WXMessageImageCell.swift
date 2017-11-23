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
        msgImage.contentMode = .scaleAspectFill
        return msgImage
    }
    override func updateMessage() {
        super.updateMessage()
        let model = WXImageModel(JSONString: (self.entity?.content)!)
        self.msgImageView.kf.setImage(with: URL(fileURLWithPath: (model!.path!.localPath())))
        
        let size = self.getSize(CGSize(width: (model?.width)!, height: (model?.height)!))
        
        if self.isSelf{
            self.msgImageView.maskBackgroundImage(UIImage(named:"message_ly_send_bg")!)
            
            self.msgImageView.snp.remakeConstraints({ (maker) in
                maker.top.equalTo(self.maskBackgroundImageView)
                maker.right.equalTo(self.maskBackgroundImageView)
                maker.size.equalTo(size)
                maker.bottom.equalToSuperview().offset(-10)
            })
            
            
        }else{
            self.msgImageView.maskBackgroundImage(UIImage(named:"message_ly_receive_bg")!)
            self.msgImageView.snp.remakeConstraints({ (maker) in
                maker.top.equalTo(self.maskBackgroundImageView)
                maker.left.equalTo(self.maskBackgroundImageView)
                maker.size.equalTo(size)
                maker.bottom.equalToSuperview().offset(-10)
                
            })
            
        }
        
        DispatchQueue.main.async {
            self.layoutIfNeeded()
        }
        
        
    }
    
    func getSize(_ size:CGSize) -> CGSize {
        let imageSize = size
        
        if __CGSizeEqualToSize(imageSize, CGSize.zero) {
           return CGSize(width: 140, height: 140)
        }
        
        if imageSize.width > imageSize.height{ //横向图
            //140 最大宽高  52 ：最小高  57 最小宽度
 
            var height = 140*imageSize.height/imageSize.width
            height = height < 53 ? 53 : height
            height = height > 140 ? 140 :height
            var width = height*imageSize.width/imageSize.height
            width = width < 58 ? 58 : width
            width = width > 140 ? 140 : width
            
            return CGSize(width: width, height: height)
        }else{ //竖向图
            var width = 140*imageSize.width/imageSize.height
            width = width < 58 ? 58 : width
            width = width > 140 ? 140 : width
            
            var height = width*imageSize.height/imageSize.width
            height = height < 53 ? 53 : height
            height = height > 140 ? 140 :height
            return CGSize(width: width, height: height)
 
        }
        
        
        
    }
    
    
}
