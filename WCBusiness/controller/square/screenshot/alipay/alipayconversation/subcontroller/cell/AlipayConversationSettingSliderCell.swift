//
//  AlipayConversationSettingSliderCell.swift
//  WCBusiness
//
//  Created by Ray on 2017/11/2.
//  Copyright © 2017年 LYL. All rights reserved.
//

import UIKit
import SnapKit
class AlipayConversationSettingSliderCell: UITableViewCell {
    lazy var titleLabel = UILabel()
    lazy var slider = UISlider()
    lazy var sliderValueLabel = UILabel()
    var sliderValue = 0.1
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style , reuseIdentifier: reuseIdentifier)
        initView ()
    }
    func initView (){
        titleLabel = UILabel.init()
        self.addSubview(titleLabel)
        titleLabel.textColor = UIColor.black
        titleLabel.textAlignment = .left
        titleLabel.font = UIFont.systemFont(ofSize: 15);
        titleLabel.text = "语音时间";
        titleLabel.snp.makeConstraints({(maker) in
            maker.centerY.equalToSuperview()
            maker.left.equalToSuperview().offset(20)
            maker.height.equalTo(20)
        })
        
        slider = UISlider.init(frame: CGRect.zero)
        self.addSubview(slider)
        slider.minimumValue = 1  //最小值
        slider.maximumValue = 60  //最大值
        slider.value = 1  //当前默认值
        slider.isContinuous = true  //滑块滑动停止后才触发ValueChanged事件
        slider.addTarget(self,action:#selector(sliderDidchange(slider:)), for:UIControlEvents.valueChanged)
        slider.snp.makeConstraints { (maker) in
            maker.centerY.equalToSuperview()
            maker.width.equalTo(self.bounds.width/2.5)
            maker.right.equalToSuperview().offset(-10)
        }
        
        
        sliderValueLabel = UILabel.init()
        self.addSubview(sliderValueLabel)
        sliderValueLabel.textColor = UIColor.black
        sliderValueLabel.textAlignment = .left
        sliderValueLabel.font = UIFont.systemFont(ofSize: 15);
        sliderValueLabel.text = "01秒"
        sliderValueLabel.snp.makeConstraints({(maker) in
            maker.centerY.equalToSuperview()
            maker.width.equalTo(40)
            maker.height.equalTo(20)
            maker.right.equalTo(self.slider.snp.left).offset(-5)
        })
    }
    func sliderDidchange(slider:UISlider){
        if Int(slider.value) < 10 {
            sliderValueLabel.text = "0\(Int(slider.value))秒"
        } else {
            sliderValueLabel.text = "\(Int(slider.value))秒"
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
