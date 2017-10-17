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
            [["name":"微信单聊","icon":"icon"],
             ["name":"微信群聊","icon":"icon"],
             ["name":"微信红包","icon":"icon"],
             ["name":"微信零钱","icon":"icon"],
             ["name":"微信转账","icon":"icon"],
             ["name":"微信提现","icon":"icon"]
                
            ]
            ,[
                ["name":"支付宝对话","icon":"icon"],
                ["name":"支付宝转账","icon":"icon"],
                ["name":"支付宝红包","icon":"icon"],
                ["name":"支付余额","icon":"icon"],
                ["name":"支付宝提现","icon":"icon"]
            ]
    ]
    override init(frame: CGRect) {
        super.init(frame: frame)
        initTitleView()
        initCollectionView()
        initCancelBtn()
    }
    func initTitleView() -> Void {
        title = UILabel.init(frame:CGRect.zero);
        title?.text = "ce";
        self.addSubview(title!);
        title?.snp.makeConstraints { (maker) in
            maker.left.top.right.equalToSuperview()
            maker.width.equalTo(self.frame.width)
            maker.height.equalTo(30)
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
        collectionView?.register(ScreenshotCollectionCell.self, forCellWithReuseIdentifier: "cell")
        collectionView?.register(WXZFBHeaderResuableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "headerCell")
        
        collectionView?.showsVerticalScrollIndicator = false
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.delegate = self;
        collectionView?.dataSource = self;
        
        collectionView?.snp.makeConstraints({ (maker) in
            maker.left.right.equalToSuperview()
            maker.bottom.equalToSuperview().offset(-44)
        })
    }
    func initCancelBtn() -> Void {
        initCancelBtn = UIButton.init(frame:CGRect.zero);
        initCancelBtn?.setImage(UIImage.init(named: "portrait"), for: .normal);
        initCancelBtn?.addTarget(self,action:#selector(rightItemBtnAction), for: .touchUpInside)
        initCancelBtn?.snp.makeConstraints({(maker) in
            maker.width.equalTo(30)
            maker.height.equalTo(30)
        })
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as!  ScreenshotCollectionCell
        
        cell.setData(dataArray[indexPath.section][indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 5, left: 20, bottom: 5, right: 20)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: (SCREEN_WIDTH-48)/3, height: 120) //(SCREEN_WIDTH-(3*2-1)*10)/3
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            switch indexPath.item {
            case 0:
                break;
            case 1:
//                let screenVC = ScreenshotViewController();
//                screenVC.hidesBottomBarWhenPushed = true
//                self.navigationController?.pushViewController(screenVC, animated: true)
                break;
            default:
                break;
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var supplementaryView:UICollectionReusableView!
        if kind ==  UICollectionElementKindSectionHeader  {
            let  view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerCell", for: indexPath) as! WXZFBHeaderResuableView
            
            if indexPath.section == 0{
                view.title = "微信截图"
            }else{
                view.title = "支付宝截图"
                
            }
            supplementaryView = view
        }
        supplementaryView.backgroundColor = UIColor.init(hexString: "EFEFEF")
        collectionView.sendSubview(toBack: supplementaryView)
        return supplementaryView
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize.init(width: SCREEN_WIDTH, height: 44);
    }
    
    
}
