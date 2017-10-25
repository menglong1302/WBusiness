//
//  AlipayConversationSettingViewController.swift
//  WCBusiness
//
//  Created by Ray on 2017/10/19.
//  Copyright © 2017年 LYL. All rights reserved.
//

import UIKit
import SnapKit
import PGActionSheet
import RealmSwift

class AlipayConversationSettingViewController : BaseViewController  {
    var userId = ""
    var tableView:UITableView?
    var saveBtn:UIButton?
    var alipayCSCRV:AlipayConversationSettingCellRoleView?
    var alipayCUser:AlipayConversationUser?
    var isFriend:Bool?
    var sender:Role?
    var receiver:Role?
    var backgroundImageUrl:String?
    var isDiskImage:Bool?
    //    var window:UIWindow?
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
        self.navigationItem.title = "单聊设置"
        initView()
        initAlipayCSCRView()
        self.view.backgroundColor = UIColor.init(hexString: "EFEFF4")
        initData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        saveData()
    }
    func initView() -> Void {
        //设置tableView的frame
        let tableViewHeight = self.view.frame.height-64-44-1;
        tableView = UITableView.init(frame:CGRect.init(x:0, y:0, width:self.view.frame.width, height:tableViewHeight),style:.grouped);
        //tableView的两个代理方法
        tableView?.delegate = self;
        tableView?.dataSource = self;
        tableView?.register(AlipayConversationSettingCell.self, forCellReuseIdentifier: "cell");
        tableView?.register(AlipayConversationSettingSwitchCell.self, forCellReuseIdentifier: "switchCell");
        self.view.addSubview(tableView!)
        tableView?.reloadData()
        
        saveBtn = UIButton.init(frame:CGRect.zero);
        self.view.addSubview(saveBtn!);
        saveBtn?.backgroundColor = UIColor.init(hexString: "FF6633");
        saveBtn?.setTitleColor(UIColor.white, for: .normal);
        saveBtn?.setTitle("保存", for: .normal);
        saveBtn?.contentHorizontalAlignment = .center;
        saveBtn?.titleLabel?.font = UIFont.systemFont(ofSize: 15.0);
        saveBtn?.addTarget(self,action:#selector(saveBtnAction), for: .touchUpInside)
        saveBtn?.snp.makeConstraints({ (maker) in
            maker.left.right.bottom.equalToSuperview()
            maker.height.equalTo(44)
        })
    }
    func initAlipayCSCRView(){
        alipayCSCRV = AlipayConversationSettingCellRoleView.init(frame: CGRect.init(x:0,y:SCREEN_HEIGHT,width:SCREEN_WIDTH,height:SCREEN_HEIGHT))
    }
    func initData () {
        alipayCUser = AlipayConversationUser()
        let realm = try! Realm()
        let alipayConversationUser = realm.objects(AlipayConversationUser.self)
        if (alipayConversationUser.count > 0){
            alipayCUser = realm.object(ofType: AlipayConversationUser.self, forPrimaryKey: self.userId)
            self.sender = alipayCUser?.sender
            self.receiver = alipayCUser?.receiver
            self.isFriend = alipayCUser?.isFriend
            self.isDiskImage = alipayCUser?.isDiskImage
            self.backgroundImageUrl = alipayCUser?.backgroundImageUrl
            tableView?.reloadData()
        }
    }
    func saveBtnAction () {
        saveData()
        self.navigationController?.popViewController(animated: true)
    }
    func saveData () {
        let realm = try! Realm()
        try! realm.write {
            [weak self] in
            alipayCUser?.sender = self?.sender
            alipayCUser?.receiver = self?.receiver
            alipayCUser?.isFriend = (self?.isFriend)!
            if !(self?.backgroundImageUrl ?? "").isEmpty{
                alipayCUser?.isDiskImage = (self?.isDiskImage)!
                alipayCUser?.backgroundImageName = "default"
                alipayCUser?.backgroundImageUrl = (self?.backgroundImageUrl)!
            }
        }
        
    }
}
//talbeView 的两个代理方法的实现，其实这两个代理还能加到class声明的后面，代理方法的时候和OC里面的实现是一样的
extension AlipayConversationSettingViewController:UITableViewDataSource,UITableViewDelegate {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2;
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2;
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.section == 1 && indexPath.row == 1) {
            let switchCell = tableView.dequeueReusableCell(withIdentifier: "switchCell") as! AlipayConversationSettingSwitchCell
            switchCell.setData(["isFriend":isFriend!])
            switchCell.selectionStyle = .none
            switchCell.swichBtn.addTarget(self, action:#selector(swithClick(_:)), for:.valueChanged)
            return switchCell
        } else {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! AlipayConversationSettingCell
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                cell.setData(["title":"用户1","name":(self.sender?.nickName)!,"imageName":(self.sender?.imageName)!])
            } else {
                cell.setData(["title":"用户2","name":(self.receiver?.nickName)!,"imageName":(self.receiver?.imageName)!])
            }
        } else {
            if indexPath.row == 0 {
                if self.isDiskImage! {
                    cell.setData(["title":"修改聊天背景","name":"","imageName":""])
                    if let temp = backgroundImageUrl,!(temp.isEmpty){
                        cell.iconImage.kf.setImage(with: URL(fileURLWithPath: temp.localPath()))
                    }
                } else {
                    cell.setData(["title":"修改聊天背景","name":"","imageName":(alipayCUser?.backgroundImageName)!])
                }
            }
          }
          return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            self.view.addSubview(alipayCSCRV!);
            alipayCSCRV?.frame = CGRect.init(x:0,y:0,width:SCREEN_WIDTH,height:SCREEN_HEIGHT)
            alipayCSCRV?.roleTypeBlock = {
              [weak self] (roleType:String)  in
                if roleType == "change" {
                    let roleVC = RoleViewController()
                    roleVC.operatorType = .Select
                    self?.navigationController?.pushViewController(roleVC, animated: true)
                    roleVC.roleSelectBlock = {
                        [weak self] (role:Role) in
                        if indexPath.row == 0 {
//                            print(role)
                            self?.sender = role
                        } else if indexPath.row == 1 {
                            self?.receiver = role
                        }
                        tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.none)
                    }
                } else if roleType == "edit" {
                    let roleEditVC = RoleEditViewController()
                    if indexPath.row == 0 {
                        roleEditVC.role = self?.sender
                    } else if indexPath.row == 1 {
                        roleEditVC.role = self?.receiver
                    }
                    self?.navigationController?.pushViewController(roleEditVC, animated: true)
                    
                    roleEditVC.block = {
                        [weak self] (nickName:String,imageName:String) in
                        self?.initData()
                    }
                }
                
            }
            UIView.animate(withDuration: 0.5, animations: {
                self.alipayCSCRV?.containerView?.frame = CGRect.init(x:0,y:0,width:SCREEN_WIDTH,height:SCREEN_HEIGHT-64)
                self.alipayCSCRV?.backgroundColor = UIColor(red: 0 / 255.0, green: 0 / 255.0, blue: 0 / 255.0, alpha: 0.5)
            })
        } else {
            if indexPath.section == 1 && indexPath.row == 0 {
                let actionSheet = PGActionSheet(cancelButton: true, buttonList: ["默认","自定义"])
                actionSheet.actionSheetTranslucent = false
                present(actionSheet, animated: false, completion: {
                    actionSheet.handler = {[weak self] index  in
                        self?.dismiss(animated: false, completion: {
                            print("index = ", index)
                            if index != 0 {
                                self?.manager.clearSelectedList()
                                let nav = UINavigationController(rootViewController: (self?.photoVC)!);
                                nav.isNavigationBarHidden = true
                                self?.present(nav, animated: true, completion: nil)
                            } else {
                                self?.isDiskImage = false
                                self?.saveData()
                                self?.initData()
                            }
                        })
                    }
                })
            } else if (indexPath.section == 1 && indexPath.row == 1) {
                 print(indexPath.row);
            }
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50;
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10;
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1;
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect.init(x:0, y:0, width:self.view.frame.width, height:10.0));
        view.backgroundColor = UIColor.clear;
        return view;
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect.init(x:0, y:0, width:self.view.frame.width, height:10.0));
        view.backgroundColor = UIColor.clear;
        return view;
    }
    func swithClick(_ sender : UISwitch) {
        
        if (sender.isOn == true) {
            isFriend = true
        }else{
            isFriend = false
        }
//        print(isFriend as Any)
    }
}

extension AlipayConversationSettingViewController:HXPhotoViewControllerDelegate{
    func photoViewControllerDidCancel() {
    }
    func photoViewControllerDidNext(_ allList: [HXPhotoModel]!, photos: [HXPhotoModel]!, videos: [HXPhotoModel]!, original: Bool) {
        let model =  photos[0]
        let data = model.thumbPhoto.kf.jpegRepresentation(compressionQuality: 0.7)
        let imagename = (UUID().uuidString+".png")
        let path = imagename.localPath()
        try? data?.write(to: URL(fileURLWithPath: path))
        backgroundImageUrl = imagename
        
        self.dismiss(animated: false) {
            self.isDiskImage = true
            self.saveData()
            self.initData()
        }
    }
}


