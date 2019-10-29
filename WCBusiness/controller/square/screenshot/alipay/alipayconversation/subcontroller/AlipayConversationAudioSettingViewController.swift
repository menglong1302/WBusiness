//
//  AlipayConversationAudioSettingViewController.swift
//  WCBusiness
//
//  Created by Ray on 2017/11/2.
//  Copyright © 2017年 LYL. All rights reserved.
//

import UIKit
import SnapKit
import RealmSwift
import PGActionSheet

class AlipayConversationAudioSettingViewController: BaseViewController {
    lazy var tableView = self.initTableView()
    var dataSourse:Array<AlipayConversationContent> = []
    var index:Int!
    var isSave:Bool? = false
    var isEdit:Bool?
    var isSender:Bool? = false
    var showSwitch:Bool? = false
    var selectRole:Role?
    var originalContentSender:Role?
    var acUser:AlipayConversationUser?
    var acContent:AlipayConversationContent?
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.isEdit == true {
            self.selectRole = self.acContent?.contentSender
            self.originalContentSender = self.acContent?.contentSender
        } else {
            self.selectRole = self.acUser?.sender
        }
        initView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.iniData()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let realm = try! Realm()
        if self.isEdit == false && self.isSave == false {
            let acContent = realm.object(ofType: AlipayConversationContent.self, forPrimaryKey: self.acContent?.id)
            try! realm.write {
                realm.delete(acContent!)
            }
        }else if self.isEdit == true && self.isSave == false {
            try! realm.write {
                self.acContent?.contentSender = self.originalContentSender
            }
        }
    }
    func initView () {
        self.navigationItem.title = "语音设置"
        self.view.backgroundColor = UIColor.init(hexString: "EFEFF4")
        self.view.addSubview(self.tableView)
        let rightBtn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 30, height: 30))
        rightBtn.setTitle("保存", for: .normal)
        rightBtn.addTarget(self, action: #selector(rightBtnAction), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: rightBtn)
        
    }
    func initTableView () -> UITableView {
        let tableView = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT-64), style: .grouped)
        tableView.backgroundColor = UIColor.clear
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(AlipayConversationSettingCell.self, forCellReuseIdentifier: "cell")
        tableView.register(AlipayConversationSettingSliderCell.self, forCellReuseIdentifier: "sliderCell")
        tableView.register(AlipayConversationSettingSwitchCell.self, forCellReuseIdentifier: "switchCell")
        return tableView
    }
    func iniData () {
        if isEdit == false && self.acContent == nil{
            let realm = try! Realm()
            self.acContent = AlipayConversationContent()
            self.acContent?.id = UUID().uuidString
            self.acContent?.index = self.index!
            self.acContent?.type = "语音"
            self.acContent?.content = "01秒"
            self.acContent?.user = self.acUser
            self.acContent?.contentSender = self.acUser?.sender
            let date = NSDate()
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
            let strNowTime = timeFormatter.string(from: date as Date) as String
            self.acContent?.creatAt = strNowTime
            try! realm.write {
                realm.create(AlipayConversationContent.self, value: self.acContent as Any, update: false)
            }
        }
    }
    func rightBtnAction () {
        self.isSave = true
        let index = IndexPath.init(row: 0, section: 1)
        let cell = self.tableView.cellForRow(at: index) as! AlipayConversationSettingSliderCell
        let realm = try! Realm()
        
        try! realm.write {
            if self.isEdit == false {
                self.acContent?.content = cell.sliderValueLabel.text!
                realm.create(AlipayConversationContent.self, value: self.acContent as Any, update: true)
            } else {
                self.acContent?.content = cell.sliderValueLabel.text!
            }
        }
        self.navigationController?.popViewController(animated: true)
    }
    func swithClick(_ sender : UISwitch) {
        let realm = try! Realm()
        try! realm.write {
            if (sender.isOn == true) {
                self.acContent?.isRead = true
            }else{
                self.acContent?.isRead = false
            }
        }
    }
}
extension AlipayConversationAudioSettingViewController:UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.selectRole?.id == self.acUser?.sender?.id {
            return 1
        } else {
            if section == 1 {
                return 2
            } else {
                return 1
            }
            
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
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
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! AlipayConversationSettingCell
            if (self.selectRole?.isDiskImage)! {
                cell.setData(["title":"选择发送人","name":(self.selectRole?.nickName)!,"imageName":""])
                if !(self.selectRole?.imageUrl.isEmpty)! {
                    cell.iconImage.kf.setImage(with: URL(fileURLWithPath: (self.selectRole?.imageUrl.localPath())!))
                }
            } else {
                if (selectRole?.imageName.isEmpty)! {
                    cell.setData(["title":"选择发送人","name":(self.selectRole?.nickName)!,"imageName":""])
                } else {
                    cell.setData(["title":"选择发送人","name":(self.selectRole?.nickName)!,"imageName":(self.selectRole?.imageName)!])
                }
            }
            return cell
        } else {
            if indexPath.row == 0 {
                let sliderCell = tableView.dequeueReusableCell(withIdentifier: "sliderCell", for: indexPath) as! AlipayConversationSettingSliderCell
                sliderCell.sliderValueLabel.text = self.acContent?.content
                let str = self.acContent?.content
                let index = str?.index((str?.startIndex)!, offsetBy:2)//获取字符d的索引
                let sliderValue = Float(atof(str?.substring(to: index!)))
                sliderCell.slider.setValue(sliderValue, animated: true)
                return sliderCell
            } else {
                let switchCell = tableView.dequeueReusableCell(withIdentifier: "switchCell", for: indexPath) as!AlipayConversationSettingSwitchCell
                switchCell.titleLabel.text = "是否已读"
                switchCell.setData(["isFriend":(self.acContent?.isRead ?? true)])
                switchCell.selectionStyle = .none
                switchCell.swichBtn.addTarget(self, action:#selector(swithClick(_:)), for:.valueChanged)
                return switchCell
            }
            
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0 {
            if self.selectRole?.id == self.acUser?.sender?.id {
                self.selectRole = self.acUser?.receiver
            } else {
                self.selectRole = self.acUser?.sender
            }
            let realm = try! Realm()
            try! realm.write {
                self.acContent?.contentSender = self.selectRole
            }
            self.tableView.reloadData()
//            let actionSheet = PGActionSheet(cancelButton: true, buttonList: [(self.acUser?.sender?.nickName)!,(self.acUser?.receiver?.nickName)!])
//            actionSheet.actionSheetTranslucent = false
//            self.isSave = true
//            present(actionSheet, animated: false, completion: {
//                actionSheet.handler = {[weak self] index  in
//                    if index == 0 {
//                        self?.selectRole = self?.acUser?.sender
//                    } else {
//                        self?.selectRole = self?.acUser?.receiver
//                    }
//                    let realm = try! Realm()
//                    try! realm.write {
//                        self?.acContent?.contentSender = self?.selectRole
//                    }
//                    self?.tableView.reloadData()
//                    self?.dismiss(animated: false, completion: nil)
//                    self?.isSave = false
//                }
//            })
        }
    }
}


