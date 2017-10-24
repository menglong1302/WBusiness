//
//  ScreenshotViewController.swift
//  WCBusiness
//
//  Created by YangXL on 2017/10/12.
//  Copyright © 2017年 LYL. All rights reserved.
//

import UIKit
import SnapKit
import ChameleonFramework
class ScreenshotViewController: BaseViewController {
    var collectionView:UICollectionView?
    var roleBtn:UIButton?
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.init(hexString: "EFEFEF")
        self.navigationItem.title = "对话截图"
        self.view.backgroundColor = UIColor.flatGray
        
        initView()
    }
    func initView() -> Void {
        
        let layout = UICollectionViewFlowLayout.init()
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        
        collectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        self.view.addSubview(collectionView!)
        
        collectionView?.bounces = true
        collectionView?.backgroundColor = UIColor.white
        collectionView?.register(ScreenshotCollectionCell.self, forCellWithReuseIdentifier: "cell")
        collectionView?.register(WXZFBHeaderResuableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "headerCell")
        
        collectionView?.showsVerticalScrollIndicator = false
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.delegate = self;
        collectionView?.dataSource = self;
        
        collectionView?.snp.makeConstraints({ (maker) in
            maker.top.left.right.equalToSuperview()
            maker.bottom.equalToSuperview().offset(-44)
        })
        
        roleBtn = UIButton.init(frame: CGRect.zero)
        self.view.addSubview(roleBtn!)
        roleBtn?.backgroundColor = UIColor.white
        roleBtn?.setTitleColor(UIColor.black, for: .normal)
        roleBtn?.setTitle("角色库", for: .normal)
        roleBtn?.setImage(UIImage.init(named: "portrait"), for: .normal)
        roleBtn?.contentHorizontalAlignment = .center
        roleBtn?.imageView?.contentMode = .scaleAspectFit
        roleBtn?.imageView?.layer.masksToBounds = true
        roleBtn?.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        roleBtn?.addTarget(self, action: #selector(roleClick), for: .touchUpInside)
        roleBtn?.snp.makeConstraints({ (maker) in
            maker.left.right.bottom.equalToSuperview()
            maker.height.equalTo(44)
        })
        roleBtn?.titleLabel?.snp.makeConstraints({ (maker) in
            maker.centerX.equalToSuperview().offset(20)
            maker.height.equalTo(30)
            maker.centerY.equalToSuperview()
        })
        roleBtn?.imageView?.snp.makeConstraints({ (maker) in
            maker.width.height.equalTo(30)
            maker.right.equalTo((roleBtn?.titleLabel)!.snp.left).offset(-10)
         })
        
        
        
    }
    
    @objc func roleClick() {
        let roleVC = RoleViewController()
        roleVC.operatorType = .Edit
        self.navigationController?.pushViewController(roleVC, animated: true)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let path = UIBezierPath()
        path.move(to: CGPoint.init(x: 0, y: 0))
        path.addLine(to: CGPoint.init(x: SCREEN_WIDTH, y: 0))
        
        let shapLayer = CAShapeLayer()
        shapLayer.frame = (roleBtn?.bounds)!
        shapLayer.path = path.cgPath
        shapLayer.lineWidth = 0.5
        shapLayer.strokeColor = UIColor.init(hexString: "EFEFEF")?.cgColor
        shapLayer.fillColor = UIColor.clear.cgColor
        roleBtn?.layer.addSublayer(shapLayer)
    }
}
extension ScreenshotViewController:UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    
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
                let screenVC = ScreenshotViewController();
                screenVC.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(screenVC, animated: true)
                break;
                
            default:
                break;
                
            }
        } else {
            switch indexPath.item {
            case 0:
                let alipayConversationVC = AlipayConversationViewController();
                alipayConversationVC.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(alipayConversationVC, animated: true)
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

