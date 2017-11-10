//
//  AlipayConversationTransferSettingViewController.swift
//  WCBusiness
//
//  Created by Ray on 2017/11/6.
//  Copyright © 2017年 LYL. All rights reserved.
//

import UIKit
import SnapKit
import RealmSwift

class AlipayConversationTransferSettingViewController: BaseViewController {
    lazy var tableView = self.initTableView()
    var dataSourse:Array<AlipayConversationContent> = []
    var index:Int!
    var isSave:Bool? = false
    var isEdit:Bool?
    var amountTextField:UITextField?
    var instructionsTextField:UITextField?
    var transferAmountStr:String? = ""
    var transferInstructions:String? = ""
    var selectRole:Role?
    var originalContentSender:Role?
    var acUser:AlipayConversationUser?
    var acContent:AlipayConversationContent?
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        if self.isEdit == true {
            self.selectRole = self.acContent?.contentSender
            self.transferAmountStr = self.acContent?.content
            self.transferInstructions = self.acContent?.transferInstructions
            self.originalContentSender = self.acContent?.contentSender
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
        self.amountTextField?.resignFirstResponder()
        self.instructionsTextField?.resignFirstResponder()
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
        self.navigationItem.title = "转账设置"
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
        tableView.register(AlipayConversationSettingTextFieldCell.self, forCellReuseIdentifier: "textFieldCell")
        return tableView
    }
    func iniData () {
        if isEdit == false && self.acContent == nil{
            let realm = try! Realm()
            self.acContent = AlipayConversationContent()
            self.acContent?.id = UUID().uuidString
            self.acContent?.index = self.index!
            self.acContent?.type = "转账"
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
        self.amountTextField?.resignFirstResponder()
        self.instructionsTextField?.resignFirstResponder()
        if self.transferAmountStr?.characters.count == 0 {
            self.isSave = false
            self.view.showImageHUDText("转账金额不能为空！")
            return
        } else {
            self.isSave = true
            let realm = try! Realm()
            if self.isEdit == false {
                self.acContent?.content = self.transferAmountStr!
                self.acContent?.transferInstructions = self.transferInstructions!
                try! realm.write {
                    realm.create(AlipayConversationContent.self, value: self.acContent as Any, update: true)
                }
            } else {
                try! realm.write {
                    self.acContent?.content = self.transferAmountStr!
                    self.acContent?.transferInstructions = self.transferInstructions!
                }
            }
            self.navigationController?.popViewController(animated: true)
        }
    }
}
extension AlipayConversationTransferSettingViewController:UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            return 2
        } else {
            return 1
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
            let textFieldCell = tableView.dequeueReusableCell(withIdentifier: "textFieldCell", for: indexPath) as!AlipayConversationSettingTextFieldCell
            textFieldCell.selectionStyle = .none
            textFieldCell.textField?.tag = 100 + indexPath.row
            if indexPath.row == 0 {
                textFieldCell.textField?.text = self.transferAmountStr
                textFieldCell.textField?.placeholder = "请输入转账金额(必填)"
                textFieldCell.textField?.keyboardType = UIKeyboardType.numberPad
                self.amountTextField = textFieldCell.textField
                self.amountTextField?.delegate = self

            } else {
                textFieldCell.textField?.text = self.transferInstructions
                textFieldCell.textField?.placeholder = "请输入转账说明(选填)"
                self.instructionsTextField = textFieldCell.textField
                self.instructionsTextField?.delegate = self
            }
            return textFieldCell
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
        if textField.tag == 100 {
            self.transferAmountStr = textField.text
        } else {
            self.transferInstructions = textField.text
        }
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField.tag == 100 {
            self.transferAmountStr = textField.text
        } else {
            self.transferInstructions = textField.text
        }
        return true
    }
}
