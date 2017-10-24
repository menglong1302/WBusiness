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
//    var rigthBtn:UIButton?
//    var footerView:UIView?
//    var footerViewLeftBtn:UIButton?
//    var footerViewRightBtn:UIButton?
    var alipayCSCRV:AlipayConversationSettingCellRoleView?
    var alipayCUser:AlipayConversationUser?
    var isFriend:Bool?
    var sender:Role?
    var receiver:Role?
    //    var window:UIWindow?

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
        saveBtn?.backgroundColor = UIColor.white;
        saveBtn?.setTitleColor(UIColor.black, for: .normal);
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
            
//            role.nickName = self?.tempNickName ?? role.nickName
//            role.firstLetter =  (self?.tempNickName ?? role.nickName).getFirstLetterFromString()
//            if !(self?.tempImageUrl ?? "").isEmpty{
//                role.isLocalImage = true
//                role.imageName = ""
//                role.imageUrl = self?.tempImageUrl ?? ""
//            }
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
                cell.setData(["title":"修改聊天背景","name":"","imageName":""])
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
//                    self.present(roleVC, animated: true, completion: {
//                    })
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
//                        tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.none)

//                        if indexPath.row == 0 {
//                            print(nickName)
////                            self?.sender?.nickName = nickName
//                            print(self?.sender?.nickName as Any)
////
////                            self?.sender?.imageName = tempImage
//                        } else if indexPath.row == 1 {
////                            self?.receiver?.nickName = tempNick
////                            self?.receiver?.imageName = tempImage
//                        }
//                        tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.none)
                    }
                }
                
            }
            UIView.animate(withDuration: 0.5, animations: {
                self.alipayCSCRV?.containerView?.frame = CGRect.init(x:0,y:0,width:SCREEN_WIDTH,height:SCREEN_HEIGHT-64)
                self.alipayCSCRV?.backgroundColor = UIColor(red: 0 / 255.0, green: 0 / 255.0, blue: 0 / 255.0, alpha: 0.5)
            })
        } else {
            if indexPath.section == 1 && indexPath.row == 0 {
                let actionSheet = PGActionSheet(cancelButton: true, buttonList: ["默认","相册","照相机"])
                actionSheet.actionSheetTranslucent = false
                actionSheet.handler = {index in
                    print("index = ", index)
                }
                present(actionSheet, animated: false, completion: nil)
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

