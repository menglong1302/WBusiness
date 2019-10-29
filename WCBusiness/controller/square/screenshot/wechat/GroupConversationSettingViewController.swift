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
    lazy var manager:HXPhotoManager = {
        () in
        let manager = HXPhotoManager(type: HXPhotoManagerSelectedTypePhoto)
        manager?.cameraType = HXPhotoManagerCameraTypeFullScreen
        manager?.outerCamera = true
        manager?.openCamera = true
        manager?.saveSystemAblum = true
        manager?.singleSelected = true
        manager?.singleSelecteClip = false
        
        return manager!
    }()
    lazy var photoVC = {
        () -> HXPhotoViewController in
        let vc = HXPhotoViewController()
        vc.manager = self.manager;
        vc.delegate = self;
        return vc
    }()
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
        else if indexPath.section == 1 {
            let changeCell = tableView.dequeueReusableCell(withIdentifier: "roleCellId") as! ChangeRoleTableViewCell
            changeCell.accessoryType = .disclosureIndicator
            changeCell.hintLabel.text = "修改聊天背景"
            changeCell.nickNameLabel.isHidden = true
            if !(self.conversation?.backgroundUrl.isEmpty)!{
                changeCell.portraitIcon.kf.setImage(with:URL(fileURLWithPath: (self.conversation?.backgroundUrl.localPath())!))
                
            }else{
                changeCell.portraitIcon.image = UIImage(named: "default")
            }
            return changeCell
        }else{
            let settingCell = tableView.dequeueReusableCell(withIdentifier: "chatSettingCellId") as! ChatSettingTableViewCell
            switch indexPath.row{
            case 0:
                settingCell.hintLabel.text = "群聊名称"
                settingCell.numLabel.text = self.conversation?.groupName
                settingCell.numLabel.isHidden = false
                settingCell.swichBar.isHidden = true
                settingCell.accessoryType = .disclosureIndicator
                break
                
            case 1:
                settingCell.hintLabel.text = "群聊人数"
                settingCell.numLabel.text = String.init(describing: (self.conversation?.groupNum)!)
                settingCell.numLabel.isHidden = false
                settingCell.swichBar.isHidden = true
                settingCell.accessoryType = .disclosureIndicator
                break
            case 2:
                
                settingCell.hintLabel.text = "未读消息数"
                settingCell.numLabel.text =  String.init(describing: (self.conversation?.unReadMessageNum)!)
                settingCell.numLabel.isHidden = false
                settingCell.swichBar.isHidden = true
                settingCell.accessoryType = .disclosureIndicator
                break
            case 3:
                settingCell.hintLabel.text = "使用听筒模式"
                settingCell.numLabel.text = ""
                settingCell.numLabel.isHidden = true
                settingCell.swichBar.isHidden = false
                settingCell.swichBar.tag = 100
                settingCell.swichBar.addTarget(self, action: #selector(switchAction(_:)), for:.valueChanged)
                settingCell.accessoryType = .none
                if (self.conversation?.isUseTelephoneReceiver)!{
                    settingCell.swichBar.isOn = true
                }else{
                    settingCell.swichBar.isOn = false
                }
                break
            case 4:
                settingCell.hintLabel.text = "显示群成员昵称"
                settingCell.numLabel.text = ""
                settingCell.numLabel.isHidden = true
                settingCell.swichBar.isHidden = false
                settingCell.swichBar.tag = 101
                settingCell.swichBar.addTarget(self, action: #selector(switchAction(_:)), for:.valueChanged)
                settingCell.accessoryType = .none
                if (self.conversation?.isShowGroupMemberNickName)!{
                    settingCell.swichBar.isOn = true
                }else{
                    settingCell.swichBar.isOn = false
                }
                break
            case 5:
                settingCell.hintLabel.text = "消息免打扰"
                settingCell.numLabel.text = ""
                settingCell.numLabel.isHidden = true
                settingCell.swichBar.isHidden = false
                settingCell.swichBar.tag = 102
                settingCell.swichBar.addTarget(self, action: #selector(switchAction(_:)), for:.valueChanged)
                settingCell.accessoryType = .none
                if (self.conversation?.isIgnoreMessage)!{
                    settingCell.swichBar.isOn = true
                }else{
                    settingCell.swichBar.isOn = false
                }
                break
            default :
                break
            }
            return settingCell
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if  section == 0||section == 1 {
            return 1
        }
        return 6
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 1 {
            let actionSheet = PGActionSheet(cancelButton: true, buttonList: ["默认","自定义"])
            actionSheet.actionSheetTranslucent = false
            present(actionSheet, animated: false, completion: {
                
            })
            actionSheet.handler = {[weak self] index  in
                if index != 0 {
                    self?.dismiss(animated: false, completion: {
                        
                        self?.manager.clearSelectedList()
                        let nav = UINavigationController(rootViewController: (self?.photoVC)!);
                        nav.isNavigationBarHidden = true
                        self?.present(nav, animated: true, completion: nil)
                    })
                } else {
                    self?.dismiss(animated: false, completion: {
                        self?.conversation?.backgroundUrl = ""
                    })
                }
                
            }
        }else if(indexPath.section == 2&&indexPath.row<3){
            let vc = ContentEditViewController()
            vc.conversation = self.conversation
            switch indexPath.row{
            case 0:
                vc.editContentType = .GroupName
                
                vc.navTitle = "群聊名称"
                vc.textField.text = String((self.conversation?.groupName)!)
                break
            case 1:
                vc.editContentType = .GroupNum
                
                vc.navTitle = "群聊人数"
                vc.textField.text = String((self.conversation?.groupNum)!)
                break
            case 2:
                vc.editContentType = .UnReadMessageNum
                
                vc.navTitle = "未读消息数"
                vc.textField.text = String((self.conversation?.unReadMessageNum)!)
                break
            default :
                break
            }
            
            vc.block = {
                self.tableView.reloadData()
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    @objc func switchAction(_ swt:UISwitch) {
        let realm = try! Realm()
        
        try! realm.write {
            if swt.tag == 100{
                if swt.isOn{
                    self.conversation?.isUseTelephoneReceiver = true
                }else{
                    self.conversation?.isUseTelephoneReceiver = false
                }
            }else if swt.tag == 101{
                if swt.isOn{
                    self.conversation?.isShowGroupMemberNickName = true
                }else{
                    self.conversation?.isShowGroupMemberNickName = false
                }
            }else{
                if swt.isOn{
                    self.conversation?.isIgnoreMessage = true
                }else{
                    self.conversation?.isIgnoreMessage = false
                }
            }
        }
        
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
                        let realm = try! Realm()
                        if indexPath.row == 0{
                            try! realm.write{
                                self.conversation?.sender = role
                            }
                        }else{
                            try! realm.write{
                                self.conversation?.receivers.insert(role, at: (indexPath.row))
                                self.conversation?.receivers.remove(at: indexPath.row-1)
                            }
                        }
                        let predicate = NSPredicate(format: "parent.id = %@", (self.conversation?.id)!)
                        let results = realm.objects(WXContentEntity.self).filter(predicate)
                        
                        
                        self.peopleArray.insert(PeopleModel(role: role), at: (indexPath.row+1))
                        let oldModel =  self.peopleArray.remove(at: indexPath.row)
                        
                        try! realm.write{
                            for result in  results{
                                if result.sender?.id == oldModel.role?.id{
                                    result.sender = role
                                }
                            }
                        }
                        
                        
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
                    let model = self.peopleArray.remove(at: indexPath.row)
                    
                    let realm = try! Realm()
                    let predicate = NSPredicate(format: "parent.id = %@", (self.conversation?.id)!)
                    let results = realm.objects(WXContentEntity.self).filter(predicate)
                    
                    
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
                        for result in results {
                            if result.sender?.id == model.role?.id{
                                realm.delete(result)
                            }
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
extension GroupConversationSettingViewController:HXPhotoViewControllerDelegate{
    func photoViewControllerDidCancel() {
    }
    func photoViewControllerDidNext(_ allList: [HXPhotoModel]!, photos: [HXPhotoModel]!, videos: [HXPhotoModel]!, original: Bool) {
        let model =  photos[0]
        let data = model.thumbPhoto.kf.jpegRepresentation(compressionQuality: 0.7)
        let imagename = (UUID().uuidString+".png")
        let path = imagename.localPath()
        try? data?.write(to: URL(fileURLWithPath: path))
        let realm = try! Realm()
        try! realm.write {
            self.conversation?.backgroundUrl = imagename
            
        }
        self.dismiss(animated: true) {
            self.tableView.reloadData()
        }
    }
}
