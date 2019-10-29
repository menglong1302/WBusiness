//
//  YLMessageImageView.swift
//  WCBusiness
//
//  Created by YangXL on 2017/11/17.
//  Copyright © 2017年 LYL. All rights reserved.
//

import Foundation
class YLMessageImageView: UIImageView {
    var backgroundImage:UIImage?
    var maskLayer:CAShapeLayer?
    var contentLayer:CALayer?
    override init(frame: CGRect) {
        super.init(frame: frame)
        maskLayer = CAShapeLayer()
        maskLayer?.contentsCenter = CGRect(x: 0.5, y: 0.6, width: 0.1, height: 0.1)
        maskLayer?.contentsScale = UIScreen.main.scale
          self.layer.mask = maskLayer!
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.maskLayer?.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
     }
    func maskBackgroundImage(_ backgroundImage:UIImage) {
        let image = backgroundImage.copy()
        self.maskLayer?.contents = (image as! UIImage).cgImage
        
    }
}
