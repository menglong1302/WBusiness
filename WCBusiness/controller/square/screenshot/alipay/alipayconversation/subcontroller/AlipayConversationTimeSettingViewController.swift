//
//  AlipayConversationTimeSettingViewController.swift
//  WCBusiness
//
//  Created by Ray on 2017/11/7.
//  Copyright © 2017年 LYL. All rights reserved.
//

import UIKit
import SnapKit
import RealmSwift

class AlipayConversationTimeSettingViewController: BaseViewController {
    lazy var tableView = self.initTableView()
    var dataSourse:Array<AlipayConversationContent> = []
    var index:Int!
    var isSave:Bool? = false
    var isEdit:Bool?
    var textField:UITextField?
    var transferAmountStr:String? = ""
    var transferInstructions:String? = ""
    var time12Btn:UIButton?
    var time24Btn:UIButton?
    var timeType:String?
    var textFieldStr:String?
    var selectRole:Role?
    var acUser:AlipayConversationUser?
    var acContent:AlipayConversationContent?
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        if self.isEdit == true {
            self.selectRole = self.acContent?.contentSender
            self.textFieldStr = self.acContent?.content
            self.timeType = self.acContent?.timeType
        } else {
            self.selectRole = self.acUser?.sender
            self.timeType = "12小时制"
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
        }
    }
    func initView () {
        self.navigationItem.title = "时间设置"
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
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(AlipayConversationSettingTextFieldCell.self, forCellReuseIdentifier: "textFieldCell")
        tableView.register(AlipayConversationSettingTimeButtonCell.self, forCellReuseIdentifier: "timeButtonCell")
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(tableViewTap))
        tableView.addGestureRecognizer(tap)
        return tableView
    }
    func tableViewTap () {
        self.textField?.resignFirstResponder()
    }
    func iniData () {
        if isEdit == false && self.acContent == nil{
            let realm = try! Realm()
            self.acContent = AlipayConversationContent()
            self.acContent?.id = UUID().uuidString
            self.acContent?.index = self.index!
            self.acContent?.type = "时间"
            self.acContent?.timeType = self.timeType! 
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
        self.textField?.resignFirstResponder()
        self.isSave = true
        let realm = try! Realm()
        if self.isEdit == false {
            self.acContent?.content = self.textFieldStr!
            try! realm.write {
                realm.create(AlipayConversationContent.self, value: self.acContent as Any, update: true)
            }
        } else {
            try! realm.write {
                self.acContent?.content = self.textFieldStr!
            }
        }
        self.navigationController?.popViewController(animated: true)
    }
    func timeButton12Action (button:UIButton) {
        button.backgroundColor = UIColor.init(hexString: "1BA5EA")
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.borderColor = UIColor.clear.cgColor
        self.time24Btn?.backgroundColor = UIColor.white
        self.time24Btn?.setTitleColor(UIColor.gray, for: .normal)
        self.time24Btn?.layer.borderColor = UIColor.init(hexString: "EFEFF4")?.cgColor
        self.timeType = "12小时制"
        let realm = try! Realm()
        try! realm.write {
            self.acContent?.timeType = self.timeType!
        }
        let index = IndexPath.init(row: 0, section: 0)
//        let cell = self.tableView.cellForRow(at: index) as! AlipayConversationSettingTextFieldCell
//        self.nowDate(cell: cell, timeType: self.timeType!)
//        self.tableView.reloadData()
        self.tableView.reloadRows(at: [index], with: UITableViewRowAnimation.none)

    }
    func timeButton24Action (button:UIButton) {
        button.backgroundColor = UIColor.init(hexString: "1BA5EA")
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.borderColor = UIColor.clear.cgColor
        self.time12Btn?.backgroundColor = UIColor.white
        self.time12Btn?.setTitleColor(UIColor.gray, for: .normal)
        self.time12Btn?.layer.borderColor = UIColor.init(hexString: "EFEFF4")?.cgColor
        self.timeType = "24小时制"
        let realm = try! Realm()
        try! realm.write {
            self.acContent?.timeType = self.timeType!
        }
        let index = IndexPath.init(row: 0, section: 0)
//        let cell = self.tableView.cellForRow(at: index) as! AlipayConversationSettingTextFieldCell
//        self.nowDate(cell: cell, timeType: self.timeType!)
//        self.tableView.reloadData()
        self.tableView.reloadRows(at: [index], with: UITableViewRowAnimation.none)
    }
    func nowDate(cell:AlipayConversationSettingTextFieldCell,timeType:String) {
        let date = NSDate()
        let timeFormatter = DateFormatter()
        if timeType == "24小时制" {
            timeFormatter.dateFormat = "HH:mm"
            let strNowTime = timeFormatter.string(from: date as Date) as String
            cell.textField?.text = strNowTime
        } else {
            timeFormatter.dateFormat = "HH:mm"
            let strNowTime = timeFormatter.string(from: date as Date) as String
            let hourStr = strNowTime.index(strNowTime.startIndex, offsetBy: 2)
            let prefix = strNowTime.substring(to: hourStr)
            let strToInt:Int = Int(prefix)!
            var timeStr = ""
            if strToInt > Int(12) {
                timeStr = "下午"
            } else {
                timeStr = "上午"
            }
            timeFormatter.dateFormat = "hh:mm"
            let nowTimeStr = timeFormatter.string(from: date as Date) as String
            cell.textField?.text = "\(timeStr) \(nowTimeStr)"
        }
    }
}
extension AlipayConversationTimeSettingViewController:UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {
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
            let textFieldCell = tableView.dequeueReusableCell(withIdentifier: "textFieldCell", for: indexPath) as!AlipayConversationSettingTextFieldCell
            textFieldCell.textField?.text = self.transferAmountStr
            textFieldCell.textField?.font = UIFont.systemFont(ofSize: 15)
            textFieldCell.textField?.backgroundColor = UIColor.white
            textFieldCell.textField?.textAlignment = .center
            textFieldCell.textField?.borderStyle = .none
            textFieldCell.textField?.placeholder = ""
            self.textField = textFieldCell.textField
            self.textField?.delegate = self
            self.nowDate(cell: textFieldCell,timeType: self.timeType!)
            return textFieldCell
        } else {
            let timeButtonCell = tableView.dequeueReusableCell(withIdentifier: "timeButtonCell", for: indexPath) as!AlipayConversationSettingTimeButtonCell
            timeButtonCell.tag = 100 + indexPath.row
            if timeButtonCell.tag == 100 {
                self.time12Btn = timeButtonCell.button
                if self.timeType == "12小时制" {
                    timeButton12Action(button: timeButtonCell.button!)
                }
                timeButtonCell.button?.addTarget(self, action: #selector(timeButton12Action(button:)), for: .touchUpInside)
                timeButtonCell.setData(["title" : "12小时制"])
            } else {
                self.time24Btn = timeButtonCell.button
                if self.timeType == "24小时制" {
                    timeButton24Action(button: timeButtonCell.button!)
                }
                timeButtonCell.button?.addTarget(self, action: #selector(timeButton24Action(button:)), for: .touchUpInside)
                timeButtonCell.setData(["title" : "24小时制"])
            }
            return timeButtonCell
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
        self.textFieldStr = textField.text
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.textFieldStr = textField.text
        return true
    }
}
