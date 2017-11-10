//
//  GroupPersionCollectionViewCell.swift
//  WCBusiness
//
//  Created by YangXL on 2017/10/27.
//  Copyright © 2017年 LYL. All rights reserved.
//

import Foundation
class GroupPersionCollectionViewCell: UICollectionViewCell {
    lazy var portraitIcon = self.makePortraitIcon()
    lazy var nameLabel = self.makeNameLabel()
    var model:PeopleModel?
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configer(_ model:PeopleModel)  {
        self.model = model
        if model.isAdd{
            nameLabel.text=""
            portraitIcon.image = UIImage(named:"default")
        }else{
            if (self.model?.role?.isDiskImage)!{
                portraitIcon.kf.setImage(with: URL(fileURLWithPath: (self.model?.role?.imageUrl.localPath())!))
            }else{
                portraitIcon.image = UIImage(named:(self.model?.role?.imageName)!)
            }
            nameLabel.text = self.model?.role?.nickName
        }
       
        
        
    }
    
    func initView() {
        [portraitIcon,nameLabel].forEach {
            addSubview($0)
        }
        
        portraitIcon.snp.makeConstraints { (maker) in
            maker.height.width.equalTo(50)
            maker.centerX.equalToSuperview()
            maker.top.equalTo(5)
        }
        nameLabel.snp.makeConstraints { (maker) in
            maker.height.equalTo(15)
            maker.left.equalToSuperview().offset(2)
            maker.right.equalToSuperview().offset(-2)
            maker.top.equalTo(portraitIcon.snp.bottom).offset(5)
        }
        
    }
    func makePortraitIcon() -> UIImageView {
        let view = UIImageView(frame: CGRect.zero)
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }
    
    func  makeNameLabel() -> UILabel {
        let label = UILabel(frame: CGRect.zero)
        label.font = UIFont.systemFont(ofSize: 10)
        label.textColor = UIColor.flatGray
        label.textAlignment = .center
        label.lineBreakMode = .byTruncatingTail
        return label
    }
}