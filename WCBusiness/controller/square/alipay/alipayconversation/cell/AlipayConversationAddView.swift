//
//  AlipayConversationAddView.swift
//  WCBusiness
//
//  Created by Ray on 2017/10/17.
//  Copyright © 2017年 LYL. All rights reserved.
//

import UIKit
import SnapKit

class AlipayConversationAddView: UIView {
    var title:UILabel?
    var collectionView:UICollectionView?
    var cancelBtn:UIButton?
    var dataArray =
        [
            [["name":"文本","icon":"icon"],
             ["name":"图片","icon":"icon"],
             ["name":"语音","icon":"icon"],
             ["name":"红包","icon":"icon"],
             ["name":"转账","icon":"icon"],
             ["name":"时间","icon":"icon"],
             ["name":"系统提示","icon":"icon"],
             ["name":"收款","icon":"icon"]
            ]
//            ,[
//                ["name":"支付宝对话","icon":"icon"],
//                ["name":"支付宝转账","icon":"icon"],
//                ["name":"支付宝红包","icon":"icon"],
//                ["name":"支付余额","icon":"icon"],
//                ["name":"支付宝提现","icon":"icon"]
//            ]
    ]
    override init(frame: CGRect) {
        super.init(frame: frame)
        initTitleView()
        initCollectionView()
        initCancelBtn()
    }
    func initTitleView() -> Void {
        
        title = UILabel.init(frame:CGRect.zero);
        title?.text = "选择对话类型";
        title?.font = UIFont.systemFont(ofSize: 15);
        title?.textAlignment = NSTextAlignment.center;
        title?.backgroundColor = UIColor.white;
        self.addSubview(title!);
        title?.snp.makeConstraints { (maker) in
            maker.left.top.right.equalToSuperview()
            maker.top.equalToSuperview().offset(2)
            maker.width.equalTo(self.frame.width)
            maker.height.equalTo(44)
        }
    }
    func initCollectionView() -> Void {
        
        let layout = UICollectionViewFlowLayout.init()
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        
        collectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        self.addSubview(collectionView!)
        
        collectionView?.bounces = true
        collectionView?.backgroundColor = UIColor.white
        collectionView?.register(AlipayConversationAddViewCell.self, forCellWithReuseIdentifier: "cell")
//        collectionView?.register(WXZFBHeaderResuableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "headerCell")
        
        collectionView?.showsVerticalScrollIndicator = false
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.delegate = self;
        collectionView?.dataSource = self;
        
        collectionView?.snp.makeConstraints({ (maker) in
            maker.left.right.equalToSuperview()
//            maker.width.equalTo(self.frame.width)
            maker.top.equalToSuperview().offset(44)
            maker.bottom.equalToSuperview().offset(-44)
        })
    }
    func initCancelBtn() -> Void {
        cancelBtn = UIButton.init(frame:CGRect.zero);
        cancelBtn?.setTitle("取消", for: .normal);
        cancelBtn?.backgroundColor = UIColor.white;
        cancelBtn?.setTitleColor(UIColor.black, for: .normal);
        cancelBtn?.titleLabel?.font = UIFont.systemFont(ofSize: 15.0);
        cancelBtn?.addTarget(self,action:#selector(cancelBtnAction), for: .touchUpInside)
        self.addSubview(cancelBtn!);
        cancelBtn?.snp.makeConstraints({(maker) in
            maker.left.right.bottom.equalToSuperview()
            maker.height.equalTo(44)
        })
        let lineView = UIView.init(frame: CGRect.zero);
        lineView.backgroundColor = UIColor.gray;
        cancelBtn?.addSubview(lineView);
        lineView.snp.makeConstraints({(maker) in
            maker.left.right.top.equalToSuperview()
            maker.height.equalTo(3)
        })
    }
    func cancelBtnAction() -> Void {
        self.removeFromSuperview();
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("error!")
    }
}
extension AlipayConversationAddView:UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.dataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataArray[section].count;
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as!  AlipayConversationAddViewCell
        
        cell.setData(dataArray[indexPath.section][indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 5, left: 10, bottom: 5, right: 10)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: (SCREEN_WIDTH-48)/4, height: 90)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.item);
//        if indexPath.section == 0 {
//            switch indexPath.item {
//            case 0:
//                break;
//            case 1:
//                break;
//            default:
//                break;
//            }
//        }
    }
//    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//        var supplementaryView:UICollectionReusableView!
//        if kind ==  UICollectionElementKindSectionHeader  {
//            let  view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerCell", for: indexPath) as! WXZFBHeaderResuableView
//
//            if indexPath.section == 0{
//                view.title = "微信截图"
//            }else{
//                view.title = "支付宝截图"
//
//            }
//            supplementaryView = view
//        }
//        supplementaryView.backgroundColor = UIColor.init(hexString: "EFEFEF")
//        collectionView.sendSubview(toBack: supplementaryView)
//        return supplementaryView
//    }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//        return CGSize.init(width: SCREEN_WIDTH, height: 44);
//    }
    
    
}
