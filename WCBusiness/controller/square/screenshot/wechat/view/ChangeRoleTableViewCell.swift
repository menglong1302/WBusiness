//
//  ChangeRoleTableViewCell.swift
//  WCBusiness
//
//  Created by YangXL on 2017/10/25.
//  Copyright © 2017年 LYL. All rights reserved.
//

import Foundation
class ChangeRoleTableViewCell: UITableViewCell {

    lazy var hintLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        return  label
    }()
    lazy var nickNameLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        return  label
    }()
    
    lazy var portraitIcon:UIImageView = {
        let imageView = UIImageView()
        return  imageView
    }()
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style:style, reuseIdentifier: reuseIdentifier)
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initView() {
        [hintLabel,nickNameLabel,portraitIcon].forEach {
            addSubview($0)
        }
        hintLabel.snp.makeConstraints { (maker) in
            maker.left.equalToSuperview().offset(15)
            maker.centerY.equalToSuperview()
            
        }
        portraitIcon.snp.makeConstraints { (maker) in
            maker.right.equalToSuperview().offset(-30)
            maker.centerY.equalToSuperview()
            maker.height.width.equalTo(40)
        }
        nickNameLabel.snp.makeConstraints { (maker) in
            maker.right.equalToSuperview().offset(-30)
            maker.centerY.equalToSuperview()
            
        }
        
    }
}
