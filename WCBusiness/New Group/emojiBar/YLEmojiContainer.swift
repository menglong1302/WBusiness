//
//  YLEmojiContainer.swift
//  WCBusiness
//
//  Created by YangXL on 2017/11/2.
//  Copyright © 2017年 LYL. All rights reserved.
//

import Foundation
class YLEmojiContainer: UIView {
    lazy var collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let itemWidth =   (SCREEN_WIDTH - 10 * 2) / 8.0;
        
        let padding = (SCREEN_WIDTH - 8 * itemWidth) / 2.0;
        let paddingLeft  = padding
        let  paddingRight = SCREEN_WIDTH - paddingLeft - itemWidth * 8;
        
        let itemHeight = CGFloat(150/3)
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        layout.sectionInset = UIEdgeInsetsMake(0, paddingLeft, 0, paddingRight   )
        let collection = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collection.isPagingEnabled = true
        collection.register(WXEmojiCollectionViewCell.self, forCellWithReuseIdentifier: "emojiCollectionCellId")
        collection.backgroundColor = UIColor.white
        return collection
    }()
    
    lazy var pageControl:UIPageControl = {
        let control = UIPageControl()
        control.numberOfPages = 4
        control.currentPage = 0
        control.pageIndicatorTintColor = UIColor.lightGray
        control.currentPageIndicatorTintColor = UIColor.gray
        control.hidesForSinglePage = true
        return control
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func initView(){
        self.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 180)
        
        [collectionView,pageControl].forEach {
            addSubview($0)
        }
        collectionView.snp.makeConstraints { (maker) in
            maker.left.right.top.equalToSuperview()
            maker.height.equalTo(150)
        }
        pageControl.snp.makeConstraints { (maker) in
            maker.left.right.equalToSuperview()
            maker.top.equalTo(collectionView.snp.bottom)
            maker.bottom.equalToSuperview()
            maker.height.equalTo(30).priority(999)
        }
    }
}
