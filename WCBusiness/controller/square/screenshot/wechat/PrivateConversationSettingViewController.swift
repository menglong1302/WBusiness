//
//  PrivateConversationSettingViewController.swift
//  WCBusiness
//
//  Created by YangXL on 2017/10/25.
//  Copyright © 2017年 LYL. All rights reserved.
//

import Foundation
import RealmSwift
import PGActionSheet
class PrivateConversationSettingViewController: BaseViewController {
    lazy var tableView = self.makeTableView()
    var conversation:WXConversation!
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    func initView()  {
        view.backgroundColor = UIColor.rgbq(r: 238, g: 236, b: 243, a: 1)
        navigationItem.title = "单聊设置"
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
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
        return tableView
    }
}

extension PrivateConversationSettingViewController:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 2
        case 1:
            return 1
        case 2:
            return 2
            
        default:
            return 1
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:UITableViewCell?
        if indexPath.section == 0 {
            let changeCell = tableView.dequeueReusableCell(withIdentifier: "roleCellId") as! ChangeRoleTableViewCell
            changeCell.accessoryType = .disclosureIndicator
            changeCell.nickNameLabel.isHidden = false
            switch indexPath.row{
            case 0:
                changeCell.hintLabel.text = "用户1"
                if let role = self.conversation.sender{
                    changeCell.nickNameLabel.text = role.nickName
                    if role.isDiskImage{
                        changeCell.portraitIcon.kf.setImage(with:URL(fileURLWithPath: role.imageUrl.localPath()))
                    }else{
                        changeCell.portraitIcon.image = UIImage(named: role.imageName)
                    }
                }
                cell = changeCell
                break
            case 1:
                changeCell.hintLabel.text = "用户2"
                if conversation.receivers.count > 0 {
                    if let role =  conversation.receivers.first {
                        changeCell.nickNameLabel.text = role.nickName
                        if role.isDiskImage{
                            changeCell.portraitIcon.kf.setImage(with:URL(fileURLWithPath: role.imageUrl.localPath()))
                        }else{
                            changeCell.portraitIcon.image = UIImage(named: role.imageName)
                        }
                    }
                }
                
                cell = changeCell
                break
            default :
                break
            }
        }else if indexPath.section == 1{
            let changeCell = tableView.dequeueReusableCell(withIdentifier: "roleCellId") as! ChangeRoleTableViewCell
            changeCell.accessoryType = .disclosureIndicator
            changeCell.hintLabel.text = "修改聊天背景"
            changeCell.nickNameLabel.isHidden = true
            if !self.conversation.backgroundUrl.isEmpty{
                changeCell.portraitIcon.kf.setImage(with:URL(fileURLWithPath: self.conversation.backgroundUrl.localPath()))
                
            }else{
                changeCell.portraitIcon.image = UIImage(named: "default")
            }
            cell = changeCell
        }else{
            let settingCell = tableView.dequeueReusableCell(withIdentifier: "chatSettingCellId") as! ChatSettingTableViewCell
            switch indexPath.row{
            case 0:
                settingCell.hintLabel.text = "未读消息数"
                settingCell.numLabel.text = String(self.conversation.unReadMessageNum)
                settingCell.numLabel.isHidden = false
                settingCell.swichBar.isHidden = true
                settingCell.accessoryType = .disclosureIndicator
                break
            case 1:
                settingCell.hintLabel.text = "使用听筒模式"
                settingCell.numLabel.text = ""
                settingCell.numLabel.isHidden = true
                settingCell.swichBar.isHidden = false
                settingCell.swichBar.addTarget(self, action: #selector(switchAction(_:)), for:.valueChanged)
                settingCell.accessoryType = .none
                if self.conversation.isUseTelephoneReceiver{
                    settingCell.swichBar.isOn = true
                }else{
                    settingCell.swichBar.isOn = false
                }
                break
            default :
                break
            }
            cell = settingCell
            
            
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0 {
            switch indexPath.row{
            case 0 :
                if self.conversation.sender == nil{
                    let vc = RoleViewController()
                    vc.operatorType = .Select
                    vc.roleSelectBlock = {
                        (role) in
                        let realm = try! Realm()
                        try! realm.write {
                            self.conversation.sender = role
                        }
                        
                        tableView.reloadData()
                    }
                    self.navigationController?.pushViewController(vc, animated: true)
                }else{
                    let actionSheet = PGActionSheet(cancelButton: true, buttonList: ["选择角色","编辑角色"])
                    actionSheet.actionSheetTranslucent = false
                    present(actionSheet, animated: false, completion: {
                    })
                    actionSheet.handler = {
                        [weak self] index  in
                        self?.dismiss(animated: false, completion: nil)
                        
                        if index ==  0{
                            let vc = RoleViewController()
                            vc.operatorType = .Select
                            if  self?.conversation.receivers.count != 0{
                                let tempRole = self?.conversation.receivers.first
                                vc.tempRole = tempRole
                            }
                            vc.roleSelectBlock = {
                                (role) in
                                let realm = try! Realm()
                                try! realm.write {
                                    self?.conversation.sender = role
                                }
                                
                                tableView.reloadData()
                            }
                            self?.navigationController?.pushViewController(vc, animated: true)
                        }else{
                            let vc = RoleEditViewController()
                            vc.role = self?.conversation.sender
                            vc.block = {(str1,str2) in
                                self?.tableView.reloadData()
                            }
                            self?.navigationController?.pushViewController(vc, animated: true)
                        }
                        
                    }
                }
                
                
                break
            case 1:
                if self.conversation.receivers.count == 0{
                    let vc = RoleViewController()
                    vc.operatorType = .Select
                    vc.roleSelectBlock = {
                        (role) in
                        let realm = try! Realm()
                        try! realm.write {
                            self.conversation.receivers.removeAll()
                            self.conversation.receivers.append(role)
                        }
                        
                        tableView.reloadData()
                    }
                    self.navigationController?.pushViewController(vc, animated: true)
                }else{
                    let actionSheet = PGActionSheet(cancelButton: true, buttonList: ["选择角色","编辑角色"])
                    actionSheet.actionSheetTranslucent = false
                    present(actionSheet, animated: false, completion: {
                    })
                    actionSheet.handler = {
                        [weak self] index  in
                        self?.dismiss(animated: false, completion: nil)
                        
                        if index ==  0{
                            let vc = RoleViewController()
                            vc.operatorType = .Select
                            
                            if  self?.conversation.sender != nil{
                                vc.tempRole = self?.conversation.sender
                            }
                            vc.roleSelectBlock = {
                                (role) in
                                let realm = try! Realm()
                                try! realm.write {
                                    self?.conversation.receivers.removeAll()
                                    self?.conversation.receivers.append(role)
                                }
                                
                                tableView.reloadData()
                            }
                            self?.navigationController?.pushViewController(vc, animated: true)
                        }else{
                            
                        }
                        
                        
                    }
                    
                }
                break
            default:
                break
            }
            
        }else  if indexPath.section == 1{
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
                        self?.conversation.backgroundUrl = ""
                    })
                }
                
            }
        }else{
            switch indexPath.row{
            case 0 :
                let vc = ContentEditViewController()
                vc.conversation = self.conversation
                vc.editContentType = .UnReadMessageNum
                vc.navTitle = "未读消息数"
                vc.textField.text = String(self.conversation.unReadMessageNum)
                vc.block = {
                    self.tableView.reloadData()
                }
                self.navigationController?.pushViewController(vc, animated: true)
                break
            case 1 :
                break
            default:
                break
                
            }
        }
    }
    
    @objc func switchAction(_ swt:UISwitch) {
        let realm = try! Realm()
        try! realm.write {
            if swt.isOn{
                self.conversation.isUseTelephoneReceiver = true
            }else{
                self.conversation.isUseTelephoneReceiver = false
            }
        }
        
    }
}

extension PrivateConversationSettingViewController:HXPhotoViewControllerDelegate{
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
            self.conversation.backgroundUrl = imagename
            
        }
        self.dismiss(animated: false) {
            self.tableView.reloadData()
        }
    }
}
