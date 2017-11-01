//
//  SelectPeopleTableViewCell.swift
//  WCBusiness
//
//  Created by YangXL on 2017/10/30.
//  Copyright © 2017年 LYL. All rights reserved.
//

import Foundation
class SelectPeopleTableViewCell: UITableViewCell {
    lazy var portraitIcon:UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    lazy var nameLabel:UILabel = {
        let label = UILabel()
        label.textColor = UIColor.flatBlack
        label.font = UIFont.systemFont(ofSize: 14)
        
        return label
    }()
    
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initView()
    }
    func initView(){
        [portraitIcon,nameLabel].forEach{
            addSubview($0)
        }
        
        portraitIcon.snp.makeConstraints { (maker) in
            maker.left.equalToSuperview().offset(10)
            maker.centerY.equalToSuperview()
            maker.height.width.equalTo(40)
        }
        nameLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(portraitIcon.snp.right).offset(10)
            maker.centerY.equalToSuperview()
            maker.right.equalToSuperview()
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
