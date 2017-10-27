//
//  GroupConversationSettingViewController.swift
//  WCBusiness
//
//  Created by YangXL on 2017/10/25.
//  Copyright © 2017年 LYL. All rights reserved.
//

import Foundation
import PGActionSheet
import RealmSwift
class GroupConversationSettingViewController: BaseViewController {
    
    lazy var tableView = self.makeTableView()
    var conversation:WXConversation?{
        didSet{
            if let sender = conversation?.sender{
                peopleArray.append(PeopleModel(role:sender))
            }
            
            for role in (conversation?.receivers)!{
                peopleArray.append(PeopleModel(role: role))
            }
            let model =  PeopleModel()
            model.isAdd = true
            peopleArray.append(model)
        }
    }
    var peopleArray = [PeopleModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    func initView()  {
        view.backgroundColor = UIColor.rgbq(r: 238, g: 236, b: 243, a: 1)
        navigationItem.title = "群聊设置"
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (maker) in
            maker.left.right.top.bottom.equalToSuperview()
        }
    }
    
    
    func makeTableView() -> UITableView {
        let tableView = UITableView(frame: CGRect.zero)
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = UIColor.rgbq(r: 238, g: 236, b: 243, a: 1)
        tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0 )
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ChangeRoleTableViewCell.self, forCellReuseIdentifier: "roleCellId")
        tableView.register(ChatSettingTableViewCell.self, forCellReuseIdentifier: "chatSettingCellId")
        tableView.register(GroupSelectPeopleTableViewCell.self, forCellReuseIdentifier: "groupSelectCellId")
        tableView.estimatedRowHeight = 50
        tableView.rowHeight = UITableViewAutomaticDimension
        return tableView
    }
}

extension GroupConversationSettingViewController:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            let tempCell =   tableView.dequeueReusableCell(withIdentifier: "groupSelectCellId") as! GroupSelectPeopleTableViewCell
            tempCell.collectionView.delegate = self
            tempCell.collectionView.dataSource = self
            tempCell.configer(conversation!)
            
            return tempCell
        }
        
        
        return UITableViewCell()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
}

extension GroupConversationSettingViewController:UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.peopleArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GroupPersionCellId", for: indexPath) as! GroupPersionCollectionViewCell
        cell.configer( self.peopleArray[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return  CGSize(width: (SCREEN_WIDTH-CGFloat(2*6))/5.0, height: 80)
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = self.peopleArray[indexPath.row]
        if model.isAdd {
            let roleVC = RoleViewController()
            roleVC.operatorType = .MutilSelect
            roleVC.mutilRole = self.conversation?.receivers
            roleVC.tempRole = self.conversation?.sender
            roleVC.roleSelectBlock = {
                (role) in
                if self.peopleArray.count == 1{
                    let realm = try! Realm()
                    try! realm.write{
                        self.conversation?.sender = role
                    }
                }else{
                    let realm = try! Realm()
                    try! realm.write{
                        self.conversation?.receivers.append(role)
                    }
                }
                self.peopleArray.insert(PeopleModel(role: role), at: self.peopleArray.count-1)
                
                collectionView.reloadData()
                self.tableView.reloadData()
            }
            self.navigationController?.pushViewController(roleVC, animated: true)
        }else{
            let actionSheet = PGActionSheet(cancelButton: true, buttonList: ["更换角色","编辑角色","移除角色"])
            actionSheet.actionSheetTranslucent = false
            present(actionSheet, animated: false, completion: nil)
            actionSheet.handler = { (index) in
                
                actionSheet.dismiss(animated: false, completion: nil)
                
                switch index {
                case 0:
                    let roleVC = RoleViewController()
                    roleVC.operatorType = .ChangeSelect
                    roleVC.changeIndex = indexPath.row
                    roleVC.mutilRole = self.conversation?.receivers
                    roleVC.tempRole = self.conversation?.sender
                    roleVC.roleSelectBlock = {
                        (role) in
                        if indexPath.row == 0{
                            let realm = try! Realm()
                            try! realm.write{
                                self.conversation?.sender = role
                            }
                        }else{
                            let realm = try! Realm()
                            try! realm.write{
                                self.conversation?.receivers.insert(role, at: (indexPath.row))
                                self.conversation?.receivers.remove(at: indexPath.row-1)
                            }
                        }
                        
                        self.peopleArray.insert(PeopleModel(role: role), at: (indexPath.row+1))
                        self.peopleArray.remove(at: indexPath.row)
                        
                        self.tableView.reloadData()
                        collectionView.reloadData()
                    }
                    self.navigationController?.pushViewController(roleVC, animated: true)
                    break
                case 1:
                    let roleVC =   RoleEditViewController()
                    roleVC.role = model.role
                    roleVC.block = {
                        (str1,str2) in
                        model.role = roleVC.role
                        collectionView.reloadData()
                        self.tableView.reloadData()
                    }
                    self.navigationController?.pushViewController(roleVC, animated: true)
                    
                    break
                default:
                    self.peopleArray.remove(at: indexPath.row)
                    let realm = try! Realm()
                    try! realm.write{
                        if indexPath.row == 0{
                            if self.peopleArray.count>1{
                                self.conversation?.sender = self.conversation?.receivers.first
                                self.conversation?.receivers.remove(at: 0)
                            }else{
                                self.conversation?.sender = nil
                                self.conversation?.receivers.removeAll()
                            }
                            
                        }else{
                             self.conversation?.receivers.remove(at: indexPath.row-1)
                        }
                    }
                    
                    
                    collectionView.deleteItems(at: [indexPath])
                    let time: TimeInterval = 0.5
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time, execute: {
                        self.tableView.reloadData()
                    })
                    break
                }
                
            }
        }
        
    }
    
    
}
