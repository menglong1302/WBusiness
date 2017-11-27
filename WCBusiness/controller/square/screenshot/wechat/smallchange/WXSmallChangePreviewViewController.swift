//
//  WXSmallChangePreviewViewController.swift
//  WCBusiness
//
//  Created by YangXL on 2017/11/27.
//  Copyright © 2017年 LYL. All rights reserved.
//

import Foundation
import ChameleonFramework
import YYText
class WXSmallChangePreviewViewController: UIViewController {
    var amount:String?
    
    lazy var iconImageView:UIImageView = self.makeIconImageView()
    lazy var amountLabel:UILabel = self.makeAmount()
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    func initView()  {
        
        self.view.backgroundColor = HexColor("efeff4")
        self.automaticallyAdjustsScrollViewInsets = true
        self.edgesForExtendedLayout = UIRectEdge.all
        let container = UIControl()
        container.backgroundColor = UIColor.clear
        container.addTarget(self, action: #selector(leftBtnClick), for: .touchUpInside)
        let imageView:UIImageView = {
            let view = UIImageView()
            view.image = UIImage(named:"wxback")
            view.contentMode = .scaleAspectFill
            return view
        }()
        let label:UILabel = {
            let label = UILabel()
            label.text = "返回"
            label.font = UIFont.systemFont(ofSize: 15.8)
            label.textColor = UIColor.white
            return label
        }()
        
        [imageView,label].forEach {
            container.addSubview($0)
        }
        let leftItem =  UIBarButtonItem(customView: container)
        container.snp.makeConstraints { (maker) in
            maker.width.equalTo(40)
            maker.height.equalTo(35)
        }
        imageView.snp.makeConstraints { (maker) in
            maker.left.equalToSuperview().offset(-5)
            maker.width.equalTo(15)
            maker.height.equalTo(30)
            maker.centerY.equalToSuperview()
        }
        label.snp.makeConstraints { (maker) in
            maker.centerY.equalToSuperview().offset(0.8)
            maker.left.equalTo(imageView.snp.right).offset(-0.3)
        }
        self.navigationItem.leftBarButtonItem = leftItem
        
        let titleView:UILabel = {
            let label = UILabel()
            label.text = "零钱"
            label.textColor = UIColor.white
            label.font = UIFont.boldSystemFont(ofSize: 19)
            label.numberOfLines = 1
            label.lineBreakMode = .byTruncatingTail
            return label
        }()
        self.navigationItem.titleView = titleView
        
        let btn = UIButton(type: .custom)
        btn.setTitle("零钱明细", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15.8)
        btn.contentHorizontalAlignment = .right;
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false;
        btn.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, -10)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: btn)
        
        self.view.addSubview(self.iconImageView)
        self.iconImageView.snp.makeConstraints { (maker) in
            maker.centerX.equalToSuperview()
            maker.width.height.equalTo(105)
            maker.top.equalToSuperview().offset(100)
        }
        
        let  hintLabel:UILabel = UILabel()
        hintLabel.textColor = UIColor.black
        hintLabel.font = UIFont.systemFont(ofSize: 15)
        hintLabel.text = "我的零钱"
        self.view.addSubview(hintLabel)
        hintLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(self.iconImageView.snp.bottom).offset(20)
            maker.centerX.equalToSuperview()
        }
        
        self.view.addSubview(self.amountLabel)
        self.amountLabel.snp.makeConstraints { (maker) in
            maker.centerX.equalToSuperview()
            maker.top.equalTo(hintLabel.snp.bottom).offset(10)
        }
        self.amountLabel.text = "¥\(String(describing: (self.amount)!))"
        
        
        let payBtn:UIButton = UIButton(type: .custom)
        payBtn.layer.cornerRadius = 5
        payBtn.layer.masksToBounds = true
        payBtn.backgroundColor = HexColor("1aad19")
        payBtn.setTitle("充值", for: .normal)
        payBtn.setTitleColor(UIColor.white, for: .normal)
        payBtn.layer.borderColor = HexColor("179c17")?.cgColor
        payBtn.layer.borderWidth = 1
        
        let withdrawBtn:UIButton = UIButton(type: .custom)
        withdrawBtn.layer.cornerRadius = 5
        withdrawBtn.layer.masksToBounds = true
        withdrawBtn.backgroundColor = UIColor.white
        withdrawBtn.setTitle("提现", for: .normal)
        withdrawBtn.setTitleColor(UIColor.black, for: .normal)
        payBtn.layer.borderColor = HexColor("dfdfdf")?.cgColor
        payBtn.layer.borderWidth = 1
        [payBtn,withdrawBtn].forEach({
            self.view.addSubview($0)
        })
        payBtn.snp.makeConstraints { (maker) in
            maker.top.equalTo(self.amountLabel.snp.bottom).offset(30)
            maker.left.equalToSuperview().offset(10)
            maker.right.equalToSuperview().offset(-10)
            maker.height.equalTo(46)
        }
        withdrawBtn.snp.makeConstraints { (maker) in
            maker.top.equalTo(payBtn.snp.bottom).offset(10)
            maker.left.equalToSuperview().offset(10)
            maker.right.equalToSuperview().offset(-10)
            maker.height.equalTo(46)
        }
        
        let licaitongLabel = YYLabel()
        licaitongLabel.numberOfLines = 1;
        licaitongLabel.lineBreakMode = .byTruncatingTail
        licaitongLabel.font = UIFont.systemFont(ofSize: 13)
        licaitongLabel.preferredMaxLayoutWidth = SCREEN_WIDTH - 60
        let mod =  YYTextLinePositionSimpleModifier()
        mod.fixedLineHeight = 16
        licaitongLabel.linePositionModifier = mod
        licaitongLabel.textColor = HexColor("576b95")
        licaitongLabel.textVerticalAlignment = .center
        
        licaitongLabel.layer.cornerRadius = 5
        licaitongLabel.textContainerInset = UIEdgeInsetsMake(0, 5, 2, 5)
        
        self.view.addSubview(licaitongLabel)
        licaitongLabel.snp.makeConstraints { (maker) in
            maker.centerX.equalToSuperview()
            maker.top.equalTo(withdrawBtn.snp.bottom).offset(15)
        }
        var str = NSMutableAttributedString.yy_attachmentString(withEmojiImage: UIImage(named:"licaitong_ico")!, fontSize: 13)
        str?.append(NSAttributedString(string: " 零钱理财，让零钱安稳赚收益"))
        str?.append ( NSMutableAttributedString.yy_attachmentString(withEmojiImage: UIImage(named:"arrow_licaitong")!, fontSize: 10)!)
        str?.yy_font = UIFont.systemFont(ofSize: 14)
        str?.yy_color = HexColor("576b95")
        licaitongLabel.attributedText = str
        
    }
    @objc func leftBtnClick(){
        self.dismiss(animated: true, completion: nil)
    }
    func makeAmount() -> UILabel {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 40)
        label.textColor = UIColor.black
        return label
    }
    func makeIconImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named:"NewPayCardMoneyIcon")
        return imageView
    }
}
