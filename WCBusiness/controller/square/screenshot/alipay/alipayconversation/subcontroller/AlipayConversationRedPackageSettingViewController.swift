//
//  AlipayConversationRedPackageSettingViewController.swift
//  WCBusiness
//
//  Created by Ray on 2017/11/3.
//  Copyright © 2017年 LYL. All rights reserved.
//

import UIKit
import SnapKit
import RealmSwift
import PGActionSheet

class AlipayConversationRedPackageSettingViewController: BaseViewController {
    lazy var tableView = self.initTableView()
    var dataSourse:Array<AlipayConversationContent> = []
    var index:Int!
    var isSave:Bool? = false
    var isEdit:Bool?
    var sendBtn:UIButton?
    var receiveBtn:UIButton?
    var isSenderSelected:Bool? = true
    var textField:UITextField?
    var textFieldValue:String? = ""
    var selectRole:Role?
    var originalContentSender:Role?
    var acUser:AlipayConversationUser?
    var acContent:AlipayConversationContent?
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        if self.isEdit == true {
            self.selectRole = self.acContent?.contentSender
            self.textFieldValue = self.acContent?.content
            self.originalContentSender = self.acContent?.contentSender
            if self.acContent?.type == "发红包" {
                self.isSenderSelected = true
            } else {
                self.isSenderSelected = false
            }
        } else {
            self.selectRole = self.acUser?.sender
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.iniData()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.textField?.resignFirstResponder()
        let realm = try! Realm()
        if self.isEdit == false && self.isSave == false {
            let acContent = realm.object(ofType: AlipayConversationContent.self, forPrimaryKey: self.acContent?.id)
            try! realm.write {
                realm.delete(acContent!)
            }
        } else if self.isEdit == true && self.isSave == false {
            try! realm.write {
                self.acContent?.contentSender = self.originalContentSender
            }
        }
    }
    func initView () {
        self.navigationItem.title = "红包设置"
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
        tableView.register(AlipayConversationSettingDoubleBtnCell.self, forCellReuseIdentifier: "doubleBtnCell")
        tableView.register(AlipayConversationSettingTextFieldCell.self, forCellReuseIdentifier: "textFieldCell")
        return tableView
    }
    func iniData () {
        if isEdit == false && self.acContent == nil{
            let realm = try! Realm()
            self.acContent = AlipayConversationContent()
            self.acContent?.id = UUID().uuidString
            self.acContent?.index = self.index!
            self.acContent?.type = "发红包"
//            self.acContent?.content = "恭喜发财，大吉大利！"
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
        self.textField?.resignFirstResponder()
//        print(self.textFieldValue!)
        let realm = try! Realm()
        if self.isEdit == false {
            if isSenderSelected == true {
                if (self.textFieldValue?.characters.count)! < 1 {
                    self.acContent?.content = "恭喜发财，大吉大利！"
                } else {
                    self.acContent?.content = self.textFieldValue!
                }
            } else {
                self.acContent?.content = ""
            }
            try! realm.write {
                realm.create(AlipayConversationContent.self, value: self.acContent as Any, update: true)
            }
        } else {
            try! realm.write {
                if isSenderSelected == true {
                    if (self.textFieldValue?.characters.count)! < 1 {
                        self.acContent?.content = "恭喜发财，大吉大利！"
                    } else {
                        self.acContent?.content = self.textFieldValue!
                    }
                } else {
                    self.acContent?.content = ""
                }
            }
        }
        self.navigationController?.popViewController(animated: true)
    }
    func sendBtnAction (button:UIButton) {
        self.isSenderSelected = true
//        self.sendBtn = button
        button.backgroundColor = UIColor.init(hexString: "1BA5EA")
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.borderColor = UIColor.clear.cgColor
        if (self.receiveBtn != nil) {
            self.receiveBtn?.backgroundColor = UIColor.white
            self.receiveBtn?.setTitleColor(UIColor.gray, for: .normal)
            self.receiveBtn?.layer.borderColor = UIColor.gray.cgColor
        }
        let realm = try! Realm()
        try! realm.write {
            self.acContent?.type = "发红包"
        }
        self.tableView.reloadData()
    }
    func receiveBtnAction (button:UIButton) {
        self.isSenderSelected = false
//        self.receiveBtn = button
        button.backgroundColor = UIColor.init(hexString: "1BA5EA")
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.borderColor = UIColor.clear.cgColor
        if (self.sendBtn != nil) {
            self.sendBtn?.backgroundColor = UIColor.white
            self.sendBtn?.setTitleColor(UIColor.gray, for: .normal)
            self.sendBtn?.layer.borderColor = UIColor.gray.cgColor
        }
        let realm = try! Realm()
        try! realm.write {
            self.acContent?.type = "收红包"
        }
        self.tableView.reloadData()
    }
}
extension AlipayConversationRedPackageSettingViewController:UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.isSenderSelected == false {
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
            cell.selectionStyle = .none
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
                let doubleBtnCell = tableView.dequeueReusableCell(withIdentifier: "doubleBtnCell", for: indexPath) as! AlipayConversationSettingDoubleBtnCell
                doubleBtnCell.selectionStyle = .none
                self.sendBtn = doubleBtnCell.sendBtn
                self.receiveBtn = doubleBtnCell.receiveBtn
                doubleBtnCell.setData(["type" : (self.acContent?.type)!])
                doubleBtnCell.sendBtn.addTarget(self, action: #selector(sendBtnAction(button:)), for: .touchUpInside)
                doubleBtnCell.receiveBtn.addTarget(self, action: #selector(receiveBtnAction(button:)), for: .touchUpInside)
                return doubleBtnCell
            } else {
                let textFieldCell = tableView.dequeueReusableCell(withIdentifier: "textFieldCell", for: indexPath) as!AlipayConversationSettingTextFieldCell
                textFieldCell.selectionStyle = .none
                if self.textFieldValue == "恭喜发财，大吉大利！" {
                    textFieldCell.textField?.text = ""
                } else {
                    textFieldCell.textField?.text = self.textFieldValue
                }
                self.textField = textFieldCell.textField
                self.textField?.delegate = self
                return textFieldCell
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
        }
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.textFieldValue = textField.text
        print(textField.text as Any)
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
