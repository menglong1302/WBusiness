//
//  PeopleTableViewCell.swift
//  WCBusiness
//
//  Created by YangXL on 2017/10/25.
//  Copyright © 2017年 LYL. All rights reserved.
//

import Foundation
import SnapKit
class PeopleTableViewCell: UITableViewCell {
    
    var imageNum:Int = 2{
        didSet{
            initImageView()
        }
    }
    var numLabel = {
        () -> UILabel in
        let label = UILabel()
        label.textColor = UIColor.flatLimeDark
        label.font = UIFont.systemFont(ofSize: 12)
        return  label
    }()
    
    lazy var hintLabel = {
        () -> UILabel in
        let label = UILabel()
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "设置资料"
        return  label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initView()
    }
    
    func initView() {
        for view in subviews{
            view.removeFromSuperview()
        }
        [hintLabel,numLabel].forEach {
            addSubview($0)
        }
         hintLabel.snp.makeConstraints { (maker) in
            maker.top.bottom.equalToSuperview()
            maker.right.equalToSuperview().offset(-30)
        }
    }
    func initImageView()  {
        if imageNum <= 2{
            numLabel.isHidden = true
        }else{
            numLabel.isHidden = false
        }
        let sum = imageNum >= 4 ? 4:imageNum
        var array = [UIImageView]()
        for i in 1...imageNum {
            let imageView = UIImageView()
            imageView.tag = 100+i
            imageView.image = UIImage(named:"portrait")
            array.append(imageView)
        }
        array.forEach { (view) in
            addSubview(view)
        }
        for i in 1...sum{
            self.viewWithTag(100+i)?.snp.makeConstraints({ (maker) in
                maker.centerY.equalToSuperview()
                maker.width.height.equalTo(35)
                maker.left.equalTo(15+5*(i-1)+(i-1)*35 )
            })
        }
        numLabel.snp.makeConstraints { (maker) in
            maker.centerY.equalToSuperview()
            maker.left.equalTo(15+5*(sum+1)+sum*35)
        }
        numLabel.text = "等\(imageNum)人"
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}








