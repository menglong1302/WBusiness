//
//  GroupSelectPeopleTableViewCell.swift
//  WCBusiness
//
//  Created by YangXL on 2017/10/26.
//  Copyright © 2017年 LYL. All rights reserved.
//

import Foundation
class GroupSelectPeopleTableViewCell: UITableViewCell {
    let num:CGFloat = 5.0
    let cellHeight:CGFloat = 80.0
    var model:PeopleModel?
    var conversation:WXConversation?
    let collectionView:UICollectionView = { ()  in
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 2
        layout.minimumInteritemSpacing = 2
        let collection = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collection.register(GroupPersionCollectionViewCell.self, forCellWithReuseIdentifier: "GroupPersionCellId")
        return collection
    }()
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func configer(_ conv:WXConversation) {
        conversation = conv
        let linNum = ceil( CGFloat((conversation?.receivers.count)!+1) / num)
        if linNum != 0 {
            collectionView.snp.remakeConstraints { (maker) in
                maker.top.equalTo(0)
                maker.left.right.equalToSuperview()
                maker.height.greaterThanOrEqualTo(linNum * cellHeight).priority(999)
                maker.bottom.equalToSuperview()

            }
        } 
       
        self.layoutIfNeeded()
    }
    func initView() {
        backgroundColor = UIColor.white
        collectionView.backgroundColor = UIColor.white
        addSubview(collectionView)
        collectionView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
    }
    
}

