//
//  AlipayConversationContentCell.swift
//  WCBusiness
//
//  Created by Ray on 2017/10/30.
//  Copyright © 2017年 LYL. All rights reserved.
//

import UIKit
import SnapKit
import YYText

class AlipayConversationContentCell:UITableViewCell {
    var model:[String:AlipayConversationContent]!
    var iconImage:UIImageView?
    var typeLabel:UILabel?
//    var contentLabel:UILabel?
    lazy var contentLabel:YYLabel = {
        let label = YYLabel()
        label.textVerticalAlignment = .top
        label.numberOfLines = 1;
        label.lineBreakMode = .byTruncatingTail
        label.font = UIFont.systemFont(ofSize: 15)
        let mod =  YYTextLinePositionSimpleModifier()
        mod.fixedLineHeight = 20
        label.linePositionModifier = mod
        
        var emojiMapper = [String:UIImage]()
        
        for index in 1...114{
            let model = EmojiModel()
            model.name = "Expression_"+String(index)+".png"
            model.mapperName = ":100\(index):"
            emojiMapper[model.mapperName!] = model.image
        }
        let parser = YYTextSimpleEmoticonParser()
        parser.emoticonMapper = emojiMapper;
        label.textParser = parser
        return label
    }()
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.addSubview(self.contentLabel)
        self.initView()
    }
    func initView () {
        self.iconImage = UIImageView.init(frame:CGRect.zero)
        self.addSubview(self.iconImage!)
        self.iconImage?.contentMode = .scaleAspectFit
        self.iconImage?.layer.cornerRadius = 1
        self.iconImage?.layer.masksToBounds = true
        self.iconImage?.snp.makeConstraints({(maker) in
            maker.centerY.equalToSuperview()
            maker.left.equalToSuperview().offset(15)
            maker.width.height.equalTo(40)
        })
        self.typeLabel = UILabel.init(frame:CGRect.zero)
        self.addSubview(self.typeLabel!)
        self.typeLabel?.textColor = UIColor.black
        self.typeLabel?.textAlignment = .left
        self.typeLabel?.font = UIFont.systemFont(ofSize: 15);
        self.typeLabel?.snp.makeConstraints({(maker) in
            maker.centerY.equalToSuperview()
            maker.left.equalTo((self.iconImage?.snp.right)!).offset(20)
            maker.height.equalTo(20)
        })
        self.contentLabel.snp.makeConstraints({(maker) in
            maker.centerY.equalToSuperview()
            maker.left.equalTo((self.typeLabel?.snp.right)!).offset(5)
            maker.right.equalToSuperview().offset(-10)
            maker.height.equalTo(20)
        })
    }
    func setData(_ model:[String:AlipayConversationContent]) {
        self.model = model
        let isDiskImage = self.model["data"]?.contentSender?.isDiskImage
        if isDiskImage == true {
            self.iconImage?.kf.setImage(with: URL(fileURLWithPath: (self.model["data"]?.contentSender?.imageUrl.localPath())!))
        } else {
            if self.model["data"]?.type == "时间" {
                self.iconImage?.image = UIImage(named:"portrait")
            } else {
                self.iconImage?.image = UIImage.init(named:(self.model["data"]?.contentSender?.imageName)!)
            }
        }
        
        let typeStr = self.model["data"]?.type
//        self.typeLabel?.text = "[\(typeStr ?? "")]"
        self.updateLabelWidthAndText(labelText: "[\(typeStr ?? "")]")
    }
    func updateLabelWidthAndText(labelText: String){
        self.typeLabel?.text = labelText
        let statusLabelSize = labelText.size(attributes: [NSFontAttributeName : UIFont.systemFont(ofSize: 15)])
        self.typeLabel?.snp.remakeConstraints({ (maker) in
            maker.centerY.equalToSuperview()
            maker.left.equalTo((self.iconImage?.snp.right)!).offset(20)
            maker.height.equalTo(20)
            maker.width.equalTo(statusLabelSize.width + 1)
        })
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
