//
//  WXEmojiCollectionViewCell.swift
//  WCBusiness
//
//  Created by YangXL on 2017/10/30.
//  Copyright © 2017年 LYL. All rights reserved.
//

import Foundation
class WXEmojiCollectionViewCell: UICollectionViewCell {
    
    lazy var imageView = {
        () -> UIImageView in
       let imageView = UIImageView(frame: CGRect.zero)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    func initView()  {
        backgroundColor = UIColor.white
        addSubview(imageView)
        imageView.snp.makeConstraints { (maker) in
             maker.edges.equalToSuperview().inset(UIEdgeInsetsMake(5, 5, 5, 5))
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
