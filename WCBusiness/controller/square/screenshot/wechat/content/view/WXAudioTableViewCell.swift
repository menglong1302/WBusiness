//
//  WXAudioTableViewCell.swift
//  WCBusiness
//
//  Created by YangXL on 2017/11/8.
//  Copyright © 2017年 LYL. All rights reserved.
//

import Foundation
import ChameleonFramework
class WXAudioTableViewCell: UITableViewCell {
    lazy var hintLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.flatBlack
        return  label
    }()
    lazy var tintLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.flatBlack
        label.textAlignment = .center
        return  label
    }()
    lazy var sliderBar:UISlider = {
        let bar = UISlider(frame: CGRect.zero)
        bar.maximumValue = 60
        bar.minimumValue = 1
        bar.maximumTrackTintColor = UIColor.lightGray
        bar.minimumTrackTintColor = HexColor("ff6633")
        return bar
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func initView() {
        [hintLabel,tintLabel,sliderBar].forEach {
            addSubview($0)
        }
        hintLabel.snp.makeConstraints { (maker) in
            maker.left.equalToSuperview().offset(15)
            maker.centerY.equalToSuperview()
            
        }
        tintLabel.snp.makeConstraints { (maker) in
            maker.right.equalToSuperview().offset(-10)
            maker.centerY.equalToSuperview()
            maker.width.equalTo(20)
        }
        sliderBar.snp.makeConstraints { (maker) in
            maker.left.equalTo(hintLabel.snp.right).offset(30)
            maker.centerY.equalToSuperview()
            maker.right.equalTo(tintLabel.snp.left).offset(-10)
        }
        
        
    }
    
}




