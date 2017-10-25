//
//  AlipayCAVHeaderResuableView.swift
//  WCBusiness
//
//  Created by Ray on 2017/10/17.
//  Copyright © 2017年 LYL. All rights reserved.
//

import UIKit
import SnapKit
import ChameleonFramework
class AlipayCAVHeaderResuableView: UICollectionReusableView {
    lazy var label = UILabel()
    lazy var containter = UIView()
    var title:String? {
        didSet{
            
            label.text = title
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
        
    }
    func initView() -> Void {
        containter = UIView.init(frame: CGRect.zero)
        self.addSubview(containter)
        containter.snp.makeConstraints { (maker) in
            maker.left.right.bottom.equalToSuperview()
//            maker.left.equalToSuperview()
            maker.height.equalTo(44)
        }
        containter.backgroundColor = UIColor.white
        
        label = UILabel.init(frame: CGRect.zero)
        self.backgroundColor = UIColor.flatGray
        label.textAlignment = NSTextAlignment.center
        containter.addSubview(label)
        label.snp.makeConstraints { (maker) in
//            maker.right.bottom.equalToSuperview()
//            maker.left.equalToSuperview().offset(20)
            maker.centerX.equalToSuperview()
            maker.height.equalTo(44)
        }
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 15)
        label.textAlignment = .left
        
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("error ")
    }
    
}
