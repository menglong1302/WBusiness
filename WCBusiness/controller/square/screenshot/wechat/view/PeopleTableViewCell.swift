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
    func confige(_ conversation:WXConversation)  {
        if let role = conversation.sender{
            let imageView = self.viewWithTag(101) as! UIImageView
            //用户存在沙盒
            if (role.isDiskImage){
                imageView.kf.setImage(with: URL(fileURLWithPath: (role.imageUrl.localPath())))
            }else {
                imageView.image = UIImage(named: (role.imageName))
            }
        }
       
        if conversation.receivers.count>0  {
          let receivers = conversation.receivers
            var i:Int = 2
            for role in receivers{
                if  let view = self.viewWithTag(100+i){
                    let imageView = view as! UIImageView
                    if (role.isDiskImage){
                        imageView.kf.setImage(with: URL(fileURLWithPath: (role.imageUrl.localPath())))
                    }else {
                        imageView.image = UIImage(named: (role.imageName))
                    }
                    i += 1
                }
                if i > 4 {
                    break
                }
            }
        }
        
    }
    func initImageView()  {
        
        for view in self.subviews {
            if view.isKind(of: UIImageView.self){
                view.removeFromSuperview()
            }
        }
        
        if imageNum <= 2{
            numLabel.isHidden = true
        }else{
            numLabel.isHidden = false
        }
        let sum = imageNum >= 4 ? 4:imageNum
        var array = [UIImageView]()
        for i in 1...4 {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.tag = 100+i
            imageView.image = UIImage(named:"portrait")
            if i <= sum{
                imageView.isHidden = false
            }else{
                imageView.isHidden = true

            }
            array.append(imageView)
        }
        array.forEach { (view) in
            addSubview(view)
        }
        for i in 1...4{
            self.viewWithTag(100+i)?.snp.remakeConstraints({ (maker) in
                maker.centerY.equalToSuperview()
                maker.width.height.equalTo(40)
                maker.left.equalTo(15+5*(i-1)+(i-1)*40 )
            })
        }
        numLabel.snp.remakeConstraints { (maker) in
            maker.centerY.equalToSuperview()
            maker.left.equalTo(15+5*(sum+1)+sum*40)
        }
        numLabel.text = "等\(imageNum)人"
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}








