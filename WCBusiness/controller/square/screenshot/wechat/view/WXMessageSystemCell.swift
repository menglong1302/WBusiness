//
//  WXMessageSystemCell.swift
//  WCBusiness
//
//  Created by YangXL on 2017/11/17.
//  Copyright © 2017年 LYL. All rights reserved.
//

import Foundation
import YYText
import ChameleonFramework
import ObjectMapper
class WXMessageSystemCell: UITableViewCell {
    
    lazy var systemLabel:YYLabel = self.makeSystemLabel()
    public var entity:WXContentEntity?
    
    public var conversation:WXConversation?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initView(){
        addSubview(systemLabel)
        self.backgroundColor = UIColor.clear
        systemLabel.snp.remakeConstraints { (maker) in
            maker.centerX.equalToSuperview()
            maker.top.equalToSuperview().offset(5)
            maker.bottom.equalToSuperview().offset(-5)
        }
    }
    
    func makeSystemLabel() -> YYLabel {
        let label = YYLabel()
         label.numberOfLines = 0;
        label.lineBreakMode = .byCharWrapping
        label.font = UIFont.systemFont(ofSize: 13)
        label.preferredMaxLayoutWidth = SCREEN_WIDTH - 60
        let mod =  YYTextLinePositionSimpleModifier()
        mod.fixedLineHeight = 16
        label.linePositionModifier = mod
        label.textColor = UIColor.white
        label.backgroundColor = HexColor("cecece", 0.9)
        label.layer.cornerRadius = 5
        label.textContainerInset = UIEdgeInsetsMake(0, 5, 2, 5)
        return label
    }
    
    func setView() {
        if self.entity?.contentType == 6{
            let model =  TimeModel(JSONString: (self.entity?.content)!)
            self.systemLabel.text = model?.timer
        }else if self.entity?.contentType == 7{
            self.systemLabel.text = self.entity?.content
        }
        
    }
}
