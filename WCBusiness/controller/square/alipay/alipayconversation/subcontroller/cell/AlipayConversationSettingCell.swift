//
//  AlipayConversationSettingCell.swift
//  WCBusiness
//
//  Created by Ray on 2017/10/19.
//  Copyright © 2017年 LYL. All rights reserved.
//

import UIKit
import SnapKit

class AlipayConversationSettingCell: UITableViewCell {
    var model:[String: String]!
    lazy var titleLabel = UILabel()
    lazy var nameLabel = UILabel()
    lazy var iconImage = UIImageView()
    lazy var arrowImage = UIImageView()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style , reuseIdentifier: reuseIdentifier)
        initView ()
    }
    func initView (){
        titleLabel = UILabel.init()
        self.addSubview(titleLabel)
        titleLabel.textColor = UIColor.black
        titleLabel.textAlignment = .left
        titleLabel.font = UIFont.systemFont(ofSize: 15);
        titleLabel.snp.makeConstraints({(maker) in
            maker.centerY.equalToSuperview()
            maker.left.equalToSuperview().offset(20)
            maker.height.equalTo(20)
        })
        arrowImage = UIImageView.init()
        self.addSubview(arrowImage)
        arrowImage.contentMode = .scaleAspectFit
        arrowImage.layer.masksToBounds = true
        arrowImage.snp.makeConstraints({(maker) in
            maker.centerY.equalToSuperview()
            maker.right.equalToSuperview().offset(-10)
            maker.height.equalTo(13)
            maker.width.equalTo(8)
        })
        iconImage = UIImageView.init()
        self.addSubview(iconImage)
        iconImage.contentMode = .scaleAspectFit
        iconImage.layer.cornerRadius = 5
        iconImage.layer.masksToBounds = true
        iconImage.snp.makeConstraints({(maker) in
            maker.centerY.equalToSuperview()
            maker.right.equalToSuperview().offset(-28)
            maker.height.equalTo(40)
            maker.width.equalTo(40)
        })
        nameLabel = UILabel.init()
        self.addSubview(nameLabel)
        nameLabel.textColor = UIColor.black
        nameLabel.textAlignment = .right
        nameLabel.font = UIFont.systemFont(ofSize: 15);
        nameLabel.snp.makeConstraints({(maker) in
            maker.centerY.equalToSuperview()
            maker.right.equalToSuperview().offset(-80)
            maker.height.equalTo(20)
        })
    }
    func setData(_ model:[String:String]) {
        self.model = model
        titleLabel.text = self.model["title"]!
        nameLabel.text = self.model["name"]!
        arrowImage.image = UIImage.init(named: "right_arrow")
        iconImage.image = UIImage.init(named: self.model["imageName"]!)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
