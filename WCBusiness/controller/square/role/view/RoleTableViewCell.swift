//
//  RoleTableViewCell.swift
//  WCBusiness
//
//  Created by YangXL on 2017/10/18.
//  Copyright © 2017年 LYL. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher
class RoleTableViewCell: UITableViewCell {
    lazy var role = Role()
    var label:UILabel?
    var portraitIcon:UIImageView?
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initView() -> Void {
        label = UILabel.init()
        portraitIcon = UIImageView.init()
        self.addSubview(label!)
        self.addSubview(portraitIcon!)
        
        portraitIcon?.snp.makeConstraints({ (maker) in
            maker.width.height.equalTo(40)
            maker.centerY.equalToSuperview()
            maker.left.equalTo(15)
        })
        label?.snp.makeConstraints({ (maker) in
            maker.right.top.bottom.equalToSuperview()
            maker.left.equalTo((portraitIcon?.snp.right)!).offset(10)
        })
    }
    func setModel(_ role:Role){
        self.role = role
        
        label?.text = role.nickName
        
        if !self.role.isDiskImage{
            portraitIcon!.image = UIImage.init(named: self.role.imageName)
        }else{
            portraitIcon?.kf.indicatorType = .activity
            var path = NSHomeDirectory() + "/Documents/"
            path.append(self.role.imageUrl)
            portraitIcon?.kf.setImage(with:URL(fileURLWithPath: path), placeholder: nil, options: [.transition(ImageTransition.fade(1))], progressBlock: nil, completionHandler: nil)
        }
    }
}
