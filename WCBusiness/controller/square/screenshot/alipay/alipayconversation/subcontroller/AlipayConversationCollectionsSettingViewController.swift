//
//  AlipayConversationCollectionsSettingViewController.swift
//  WCBusiness
//
//  Created by Ray on 2017/11/10.
//  Copyright © 2017年 LYL. All rights reserved.
//

import UIKit
import SnapKit
import RealmSwift
import PGActionSheet

class AlipayConversationCollectionsSettingViewController: BaseViewController {
    lazy var tableView = self.initTableView()
    var dataSourse:Array<AlipayConversationContent> = []
    var index:Int!
    var isSave:Bool? = false
    var isEdit:Bool?
    var sendBtn:UIButton?
    var receiveBtn:UIButton?
    var isCollectionsSelected:Bool? = true
    var textField:UITextField?
    var textFieldValue:String? = ""
    var selectRole:Role?
    var originalContentSender:Role?
    var acUser:AlipayConversationUser?
    var acContent:AlipayConversationContent?
    var amountTextField:UITextField?
    var instructionsTextField:UITextField?
    var amountStr:String? = ""
    var instructionsStr:String? = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        if self.isEdit == true {
            self.selectRole = self.acContent?.contentSender
            self.amountStr = self.acContent?.content
            self.instructionsStr = self.acContent?.transferInstructions
            self.originalContentSender = self.acContent?.contentSender
            if self.acContent?.type == "收款" {
                self.isCollectionsSelected = true
            } else {
                self.isCollectionsSelected = false
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
        self.navigationItem.title = "收款设置"
        self.view.backgroundColor = UIColor.init(hexString: "EFEFF4")
        self.view.addSubview(self.tableView)
        let rightBtn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 30, height: 30))
        rightBtn.setTitle("保存", for: .normal)
        rightBtn.addTarget(self, action: #selector(rightBtnAction), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: rightBtn)
    }
    func initTableView () -> UITableView {
        let tableView = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT-64), style: .grouped)
//        let tap = UITapGestureRecognizer.init(target: self, action: #selector(tableViewTap))
//        tableView.addGestureRecognizer(tap)
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
            self.acContent?.type = "收款"
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
    func tableViewTap () {
        self.view.endEditing(true)
    }
    func rightBtnAction () {
        self.amountTextField?.resignFirstResponder()
        self.instructionsTextField?.resignFirstResponder()
        if self.amountStr?.characters.count == 0 {
            self.isSave = false
            self.view.showImageHUDText("金额不能为空！")
            return
        } else {
            self.isSave = true
            let realm = try! Realm()
            if self.isEdit == false {
                self.acContent?.content = self.amountStr!
                self.acContent?.transferInstructions = self.instructionsStr!
                try! realm.write {
                    realm.create(AlipayConversationContent.self, value: self.acContent as Any, update: true)
                }
            } else {
                try! realm.write {
                    self.acContent?.content = self.amountStr!
                    self.acContent?.transferInstructions = self.instructionsStr!
                }
            }
            self.navigationController?.popViewController(animated: true)
        }
    }
    func sendBtnAction (button:UIButton) {
        self.isCollectionsSelected = true
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
            self.acContent?.type = "收款"
        }
        self.tableView.reloadData()
    }
    func receiveBtnAction (button:UIButton) {
        self.isCollectionsSelected = false
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
            self.acContent?.type = "付款"
        }
        self.tableView.reloadData()
    }
}
extension AlipayConversationCollectionsSettingViewController:UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            if self.isCollectionsSelected == true {
                return 3
            } else {
                return 2
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
                doubleBtnCell.sendBtn.setTitle("收款", for: .normal)
                doubleBtnCell.receiveBtn.setTitle("付款", for: .normal)
                doubleBtnCell.setData(["type" : (self.acContent?.type)!])
                doubleBtnCell.sendBtn.addTarget(self, action: #selector(sendBtnAction(button:)), for: .touchUpInside)
                doubleBtnCell.receiveBtn.addTarget(self, action: #selector(receiveBtnAction(button:)), for: .touchUpInside)
                self.sendBtn = doubleBtnCell.sendBtn
                self.receiveBtn = doubleBtnCell.receiveBtn
                return doubleBtnCell
            } else {
                let textFieldCell = tableView.dequeueReusableCell(withIdentifier: "textFieldCell", for: indexPath) as!AlipayConversationSettingTextFieldCell
                textFieldCell.selectionStyle = .none
                textFieldCell.textField?.tag = 100 + indexPath.row
                if indexPath.row == 1 {
                    textFieldCell.textField?.text = self.amountStr
                    textFieldCell.textField?.placeholder = "金额"
                    textFieldCell.textField?.keyboardType = UIKeyboardType.numberPad
                    self.amountTextField = textFieldCell.textField
                    self.amountTextField?.delegate = self
                    
                } else {
                    textFieldCell.textField?.text = self.instructionsStr
                    textFieldCell.textField?.placeholder = "备注"
                    self.instructionsTextField = textFieldCell.textField
                    self.instructionsTextField?.delegate = self
                }
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
        if textField.tag == 101 {
            self.amountStr = textField.text
        } else if textField.tag == 102  {
            self.instructionsStr = textField.text
        }
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField.tag == 101 {
            self.amountStr = textField.text
        } else if textField.tag == 102 {
            self.instructionsStr = textField.text
        }
        return true
    }
}
