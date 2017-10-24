//
//  AlipayConversationSettingInfoCell.swift
//  WCBusiness
//
//  Created by Ray on 2017/10/24.
//  Copyright © 2017年 LYL. All rights reserved.
//

import UIKit
import SnapKit

class AlipayConversationSettingInfoCell: UITableViewCell {
    var model:[String: String]!
    lazy var iconImage1 = UIImageView()
    lazy var iconImage2 = UIImageView()
    lazy var nameLabel = UILabel()
    lazy var arrowImage = UIImageView()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style , reuseIdentifier: reuseIdentifier)
        initView ()
    }
    func initView (){
        iconImage1 = UIImageView.init()
        self.addSubview(iconImage1)
        iconImage1.contentMode = .scaleAspectFit
        iconImage1.layer.masksToBounds = true
        iconImage1.snp.makeConstraints({(maker) in
            maker.top.bottom.equalToSuperview()
            maker.left.equalToSuperview().offset(20)
            maker.width.height.equalTo(40)
        })
        
        iconImage2 = UIImageView.init()
        self.addSubview(iconImage2)
        iconImage2.contentMode = .scaleAspectFit
        iconImage2.layer.cornerRadius = 8
        iconImage2.layer.masksToBounds = true
        iconImage2.snp.makeConstraints({(maker) in
            maker.top.bottom.equalToSuperview()
            maker.left.equalToSuperview().offset(70)
            maker.width.height.equalTo(40)
        })
        
        arrowImage = UIImageView.init()
        self.addSubview(arrowImage)
        arrowImage.contentMode = .scaleAspectFit
        arrowImage.layer.masksToBounds = true
        arrowImage.snp.makeConstraints({(maker) in
            maker.top.bottom.equalToSuperview()
            maker.right.equalToSuperview().offset(-10)
            maker.height.equalTo(13)
            maker.width.equalTo(8)
        })
        
        nameLabel = UILabel.init()
        self.addSubview(nameLabel)
        nameLabel.textColor = UIColor.black
        nameLabel.textAlignment = .right
        nameLabel.font = UIFont.systemFont(ofSize: 15);
        nameLabel.snp.makeConstraints({(maker) in
            maker.top.bottom.equalToSuperview()
            maker.right.equalToSuperview().offset(-28)
            maker.height.equalTo(20)
        })
    }
    func setData(_ model:[String:String]) {
        self.model = model
        nameLabel.text = self.model["name"]!
        arrowImage.image = UIImage.init(named: "right_arrow")
        iconImage1.image = UIImage.init(named: self.model["imageName1"]!)
        iconImage2.image = UIImage.init(named: self.model["imageName2"]!)
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

