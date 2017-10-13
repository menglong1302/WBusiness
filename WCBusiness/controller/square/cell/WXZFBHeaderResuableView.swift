//
//  WXZFBHeaderResuableView.swift
//  WCBusiness
//
//  Created by YangXL on 2017/10/13.
//  Copyright © 2017年 LYL. All rights reserved.
//

import UIKit
import SnapKit
class WXZFBHeaderResuableView: UICollectionReusableView {
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
            maker.right.bottom.equalToSuperview()
            maker.left.equalToSuperview()
            maker.height.equalTo(30)
        }
        containter.backgroundColor = UIColor.white
        
        label = UILabel.init(frame: CGRect.zero)
        self.backgroundColor = UIColor.flatGray
        containter.addSubview(label)
        label.snp.makeConstraints { (maker) in
            maker.right.bottom.equalToSuperview()
            maker.left.equalToSuperview().offset(20)
            maker.height.equalTo(30)
        }
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .left
       
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("error ")
    }
    
}
