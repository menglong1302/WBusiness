//
//  WBSquareViewController.swift
//  WCBusiness
//
//  Created by YangXL on 2017/10/11.
//  Copyright © 2017年 LYL. All rights reserved.
//

import UIKit
import ChameleonFramework
import SnapKit
class WBSquareViewController: BaseViewController  {
   
    var collectionView:UICollectionView!
    var dataArray = [["name":"文章撰写","image":"image1"],["name":"对话截图","image":"image1"],["name":"简洁拼接","image":"image1"],["name":"视频海报","image":"image1"],["name":"图片海报","image":"image1"],["name":"批量水印","image":"image1"],["name":"微商资讯","image":"image1"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "工厂"
        self.isShowBack = false
        initView()
    }
    func initView() {
        let layout = UICollectionViewFlowLayout.init()
        layout.minimumInteritemSpacing = 2
        layout.minimumLineSpacing = 20
        self.collectionView = UICollectionView.init(frame: self.view.bounds, collectionViewLayout: layout)
        self.collectionView.bounces = true
        self.collectionView.backgroundColor = UIColor.white
        self.collectionView.register(SquareCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        self.view.addSubview(self.collectionView!)
        
        self.collectionView.snp.makeConstraints { (maker) in
            maker.top.equalToSuperview()
            maker.left.equalToSuperview()
            maker.right.equalToSuperview()
            maker.bottom.equalToSuperview()
        }
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
}

extension WBSquareViewController:UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataArray.count;
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as!  SquareCollectionViewCell
        
        cell.setData(dataArray[indexPath.item])
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
}











