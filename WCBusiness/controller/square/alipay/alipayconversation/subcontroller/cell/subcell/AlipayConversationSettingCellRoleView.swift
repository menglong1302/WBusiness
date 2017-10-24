//
//  AlipayConversationSettingCellRoleView.swift
//  WCBusiness
//
//  Created by Ray on 2017/10/20.
//  Copyright © 2017年 LYL. All rights reserved.
//

import UIKit
import SnapKit
typealias RoleTypeBlock = (String) -> ()

class AlipayConversationSettingCellRoleView: UIView {
    var roleTypeBlock:RoleTypeBlock?
    var containerView:UIView?
    var tapGestureView:UIView?
    var collectionView:UICollectionView?
    var cancelBtn:UIButton?
    var dataArray = [["name":"更换角色","icon":"icon"],["name":"编辑角色","icon":"icon"]]
    var nav:UINavigationController?
    override init(frame: CGRect) {
        super.init(frame: frame)
        initContainerView()
        initTapGestureView()
        initCollectionView()
        initCancelBtn()
    }
    func initContainerView() -> Void {
        containerView = UIView.init(frame:CGRect.init(x:0,y:SCREEN_HEIGHT,width:SCREEN_WIDTH,height:SCREEN_HEIGHT-64));
        self.addSubview(containerView!);
    }
    func initTapGestureView() -> Void {
        tapGestureView = UIView.init(frame:CGRect.init(x:0,y:0,width:SCREEN_WIDTH,height:SCREEN_HEIGHT-64-115-44));
        self.addSubview(tapGestureView!);
        tapGestureView?.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cancelBtnAction))
        tapGesture.numberOfTapsRequired = 1
        tapGestureView?.addGestureRecognizer(tapGesture)
    }
    func initCollectionView() -> Void {
        
        let layout = UICollectionViewFlowLayout.init()
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        
        collectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        containerView?.addSubview(collectionView!)
        collectionView?.bounces = true
        collectionView?.backgroundColor = UIColor.white
        collectionView?.register(AlipayConversationSettingCellRoleViewCell.self, forCellWithReuseIdentifier: "cell")
//        collectionView?.register(AlipayCAVHeaderResuableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "headerCell")
        collectionView?.isScrollEnabled = false
        collectionView?.showsVerticalScrollIndicator = false
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.delegate = self;
        collectionView?.dataSource = self;
        
        collectionView?.snp.makeConstraints({ (maker) in
            maker.left.right.equalToSuperview()
            maker.height.equalTo(115)
            maker.bottom.equalToSuperview().offset(-44)
        })
    }
    func initCancelBtn() -> Void {
        cancelBtn = UIButton.init(frame:CGRect.init(x:0,y:SCREEN_HEIGHT-64-47,width:SCREEN_WIDTH,height:47));
        containerView?.addSubview(cancelBtn!);
        cancelBtn?.setTitle("取消", for: .normal);
        cancelBtn?.backgroundColor = UIColor.white;
        cancelBtn?.setTitleColor(UIColor.black, for: .normal);
        cancelBtn?.titleLabel?.font = UIFont.systemFont(ofSize: 15.0);
        cancelBtn?.addTarget(self,action:#selector(cancelBtnAction), for: .touchUpInside)
        let lineView = UIView.init(frame: CGRect.zero);
        lineView.backgroundColor = UIColor.gray;
        cancelBtn?.addSubview(lineView);
        lineView.snp.makeConstraints({(maker) in
            maker.left.right.top.equalToSuperview()
            maker.height.equalTo(3)
        })
    }
    
    func cancelBtnAction() -> Void {
        //        self.tag = 101
        //        if let window = UIApplication.shared.keyWindow{
        //            window.viewWithTag(self.tag)?.removeFromSuperview()
        //        }
        UIView.animate(withDuration: 0.5, animations: {
            self.containerView?.frame = CGRect.init(x:0,y:SCREEN_HEIGHT,width:SCREEN_WIDTH,height:SCREEN_HEIGHT-64)
            self.backgroundColor = UIColor(red: 0 / 255.0, green: 0 / 255.0, blue: 0 / 255.0, alpha: 0)
        }) { (complete) in
            if (complete) {
                self.removeFromSuperview();
            }
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("error!")
    }
}
extension AlipayConversationSettingCellRoleView:UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1;
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataArray.count;
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as!  AlipayConversationSettingCellRoleViewCell
        
        cell.setData(dataArray[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 15, left: (SCREEN_WIDTH-80)/4, bottom: 15, right: (SCREEN_WIDTH-80)/4)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: 80, height: 85)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("123");
        print(indexPath.item);
        if indexPath.row == 0 {
            roleTypeBlock!("change")
        } else {
            roleTypeBlock!("edit")
        }
        self.cancelBtnAction()
    }

//    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//        var supplementaryView:UICollectionReusableView!
//        if kind ==  UICollectionElementKindSectionHeader  {
//            let  view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerCell", for: indexPath) as! AlipayCAVHeaderResuableView
//            view.title = "选择对话类型"
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
