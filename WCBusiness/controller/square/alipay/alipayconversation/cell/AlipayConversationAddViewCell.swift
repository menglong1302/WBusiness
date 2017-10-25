//
//  AlipayConversationAddViewCell.swift
//  WCBusiness
//
//  Created by Ray on 2017/10/17.
//  Copyright © 2017年 LYL. All rights reserved.
//

import UIKit

class AlipayConversationAddViewCell: UICollectionViewCell {
    
    var model:[String: String]!
    lazy var nameLabel = UILabel()
    lazy var iconImage = UIImageView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        nameLabel = UILabel.init()
        iconImage = UIImageView.init()
        initView()
    }
    
    func initView(){
        self.contentView.addSubview(nameLabel)
        self.contentView.addSubview(iconImage)
        nameLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.height.equalTo(20)
            make.bottom.equalToSuperview().offset(-5)
        }
        iconImage.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.width.equalTo(50)
            make.height.equalTo(50)
            make.bottom.equalToSuperview().offset(-30)
        }
        nameLabel.textColor = UIColor.black
        nameLabel.textAlignment = .center
        nameLabel.font = UIFont.systemFont(ofSize: 13);
        
        iconImage.contentMode = .scaleAspectFit
        iconImage.layer.cornerRadius = 25
        iconImage.layer.masksToBounds = true
    }
    
    func setData(_ model:[String:String]) {
        self.model = model
        
        nameLabel.text = self.model["name"]!
        iconImage.image = UIImage.init(named: "portrait")
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

