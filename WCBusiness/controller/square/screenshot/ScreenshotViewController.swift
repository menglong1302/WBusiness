//
//  ScreenshotViewController.swift
//  WCBusiness
//
//  Created by YangXL on 2017/10/12.
//  Copyright © 2017年 LYL. All rights reserved.
//

import UIKit
import SnapKit

class ScreenshotViewController: BaseViewController {
    var collectionView:UICollectionView?
    
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
        
        self.view.backgroundColor = UIColor.white
        self.navigationItem.title = "对话截图"
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
        collectionView?.register(SquareCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView?.register(WXZFBHeaderResuableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "headerCell")
        collectionView?.delegate = self;
        collectionView?.dataSource = self;
        
        collectionView?.snp.makeConstraints({ (maker) in
            maker.top.left.right.equalToSuperview()
            maker.bottom.equalToSuperview().offset(-50)
        })
        
    }
}
extension ScreenshotViewController:UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataArray[section].count;
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as!  SquareCollectionViewCell

//        cell.setData(dataArray[indexPath.item])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 40, left: 20, bottom: 10, right: 20)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: (SCREEN_WIDTH-48)/3, height: 120) //(SCREEN_WIDTH-(3*2-1)*10)/3
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
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
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
         var supplementaryView:WXZFBHeaderResuableView!
        if kind ==  UICollectionElementKindSectionHeader  {
              supplementaryView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerCell", for: indexPath) as! WXZFBHeaderResuableView
            
            if indexPath.section == 0{
                supplementaryView.title = "微信"
            }else{
                supplementaryView.title = "支付宝"

            }
        }
        return supplementaryView
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize.init(width: SCREEN_WIDTH, height: 44);
    }
    
}

