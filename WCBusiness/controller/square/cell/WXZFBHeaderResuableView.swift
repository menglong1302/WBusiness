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
        label = UILabel.init(frame: CGRect.zero)
        self.addSubview(label)
        label.snp.makeConstraints { (maker) in
            maker.left.right.bottom.top.equalToSuperview()
        }
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .left
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("error ")
    }
}
