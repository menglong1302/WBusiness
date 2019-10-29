//
//  WXRedPacketPreviewViewController.swift
//  WCBusiness
//
//  Created by YangXL on 2017/11/27.
//  Copyright © 2017年 LYL. All rights reserved.
//

import Foundation
import UIKit
import ChameleonFramework
class WXRedPacketPreviewViewController: UIViewController {
    var  model:WXRedPacketSetModel?
    lazy var scrollView:UIScrollView = self.makeScrollView()
    
    lazy var  rolePortrait:UIImageView = self.makeRolePortrait()
 
    lazy var nickNameLabel:UILabel = self.makeNickNameLabel()
    lazy var describeLabel:UILabel = self.makeDescribeLabel()
    lazy var amountLabel:UILabel = self.makeAmountLabel()

    lazy var ilLabel:UILabel = self.makeIlLabel()

    lazy var leaveWordLabel:UILabel = self.makeLeaveWordLabel()
    
    lazy var container:UIView = self.makeContainer()
    
    lazy var lineView:UIView = self.makeLineView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = HexColor("d85940")
        self.navigationController?.navigationBar.isTranslucent = false
         initView()
    }
    
    func initView() {
        self.automaticallyAdjustsScrollViewInsets = true
        self.edgesForExtendedLayout = UIRectEdge.all
        self.view.backgroundColor = UIColor.white
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
            label.textColor = HexColor("ffe2b1")
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
            label.text = "微信红包"
            label.textColor = HexColor("ffe2b1")
            label.font = UIFont.boldSystemFont(ofSize: 19)
            label.numberOfLines = 1
            label.lineBreakMode = .byTruncatingTail
            return label
        }()
        self.navigationItem.titleView = titleView
        
        let btn = UIButton(type: .custom)
        btn.setTitle("红包记录", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.contentHorizontalAlignment = .right;
        btn.setTitleColor(HexColor("ffe2b1"), for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false;
        btn.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, -10)
        btn.addTarget(self, action: #selector(rightBtnClick(_:)), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: btn)
        
        self.view.addSubview(self.scrollView)
        self.scrollView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
        
        let bgImageView = UIImageView()
        bgImageView.image = UIImage(named:"redpacket_circle")
        bgImageView.backgroundColor = UIColor.clear
        bgImageView.contentMode = .scaleAspectFill
        scrollView.addSubview(bgImageView)
        bgImageView.snp.makeConstraints { (maker) in
            maker.left.right.equalToSuperview()
            maker.top.equalToSuperview().offset(-46)
            maker.height.equalTo(87)
        }
        
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        scrollView.addSubview(self.rolePortrait)
        self.rolePortrait.snp.makeConstraints { (maker) in
            maker.centerX.equalToSuperview()
            maker.bottom.equalTo(bgImageView.snp.bottom).offset(50)
            maker.height.width.equalTo(62)
        }
        
        scrollView.addSubview(self.nickNameLabel)
        self.nickNameLabel.snp.makeConstraints { (maker) in
            maker.centerX.equalToSuperview()
            maker.top.equalTo(self.rolePortrait.snp.bottom).offset(10)
        }
        
        scrollView.addSubview(self.describeLabel)
        self.describeLabel.snp.makeConstraints { (maker) in
            maker.centerX.equalToSuperview()
            maker.top.equalTo(self.nickNameLabel.snp.bottom).offset(10)
        }
        
        
        if let role = self.model?.role {
            if role.isDiskImage{
                self.rolePortrait.kf.setImage(with: URL(fileURLWithPath: role.imageUrl.localPath()))
            }else{
                self.rolePortrait.image = UIImage(named:role.imageName)
            }
            nickNameLabel.text = "\(role.nickName)的红包"
        }
        describeLabel.text = self.model?.describe!
        
        
        scrollView.addSubview(self.amountLabel)
        self.amountLabel.snp.makeConstraints { (maker) in
            maker.centerX.equalToSuperview().offset(10)
            maker.top.equalTo(self.describeLabel.snp.bottom).offset(32)
        }
        self.amountLabel.text = (self.model?.amount)!
        
        let string = NSMutableAttributedString(string: (self.model?.amount)!  )
        string.addAttribute(NSFontAttributeName, value: UIFont(name: "WeChatNumber-151125", size: 50), range: NSMakeRange(0, string.length))
        let yuan = NSMutableAttributedString(string: " 元")
        yuan.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: 14), range: NSMakeRange(0, yuan.length))
        string.append(yuan)
        self.amountLabel.attributedText = string
        
        
        self.scrollView.addSubview(self.ilLabel)
        self.ilLabel.snp.makeConstraints { (maker) in
            maker.centerX.equalToSuperview()
            maker.top.equalTo(self.amountLabel.snp.bottom).offset(8)
        }
        let i =  Int(arc4random()%4)+1
        switch i {
        case 1:
            self.ilLabel.text = "已存入零钱，可直接消费"
            break
        case 2:
            self.ilLabel.text = "已存入零钱，可直接转账"
            break
        case 3:
            self.ilLabel.text = "已存入零钱，可直接提现"
            break
        default:
            self.ilLabel.text = "已存入零钱，可直接发红包"
            break
        }
        
        self.scrollView.addSubview(self.container)
        self.container.snp.makeConstraints { (maker) in
            maker.top.equalTo(self.ilLabel.snp.bottom).offset(18)
            maker.left.right.equalToSuperview()
            maker.height.equalTo(400)
            maker.bottom.equalToSuperview()
        }
        
        self.container.addSubview(self.leaveWordLabel)
        self.leaveWordLabel.snp.makeConstraints { (maker) in
            maker.centerX.equalToSuperview()
            maker.top.equalToSuperview().offset(26)
           
        }
         self.leaveWordLabel.text = "留言"
        self.container.addSubview(self.lineView)
        self.lineView.snp.makeConstraints { (maker) in
            maker.left.right.equalToSuperview()
            maker.height.equalTo(0.5)
            maker.top.equalTo(leaveWordLabel.snp.bottom).offset(26)
        }
        
     }
    func makeScrollView() -> UIScrollView {
        let scroll = UIScrollView()
        scroll.showsHorizontalScrollIndicator = false
        scroll.contentSize = self.view.frame.size
        scroll.bounces = true
        scroll.backgroundColor = HexColor("f1f1f1")
        return scroll
    }
    
    func makeRolePortrait() -> UIImageView {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 3
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 0.5
        imageView.layer.borderColor = HexColor("ffe2b1")?.cgColor
        return imageView
    }
    func makeNickNameLabel() -> UILabel {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = HexColor("303030")
        return label
    }
    func makeDescribeLabel() -> UILabel {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = HexColor("303030")
        return label
    }
    func makeAmountLabel() -> UILabel {
        let label = UILabel()
        label.font = UIFont(name: "WeChatNumber-151125", size: 14)
        label.textColor = HexColor("303030")
        return label
    }
    
    func makeIlLabel() -> UILabel {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = HexColor("5171b0")
        return label
    }
    func makeContainer() -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }
    func makeLeaveWordLabel() -> UILabel {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = HexColor("303030")
        return label
    }
    func makeLineView() -> UIView {
        let view = UIView()
        view.backgroundColor = HexColor("d9d9d9")
        return view
    }
    @objc func leftBtnClick(){
        self.dismiss(animated: true, completion: nil)
    }
    @objc func rightBtnClick(_ sender:UIButton) -> Void {
        
    }
}
