//
//  WXTimerTableViewCell.swift
//  WCBusiness
//
//  Created by YangXL on 2017/11/9.
//  Copyright © 2017年 LYL. All rights reserved.
//

import Foundation
 class WXTimerTableViewCell: UITableViewCell {
    
    lazy var timerLabel:UILabel = {
        let text = UILabel(frame: CGRect.zero)
        text.font = UIFont.boldSystemFont(ofSize: 15)
        text.textAlignment = .center
        text.textColor = UIColor.flatBlack
        return text
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initView()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("")
    }

    func  initView() {
        addSubview(timerLabel)
        timerLabel.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
            maker.height.greaterThanOrEqualTo(44)
        }
    }

}
