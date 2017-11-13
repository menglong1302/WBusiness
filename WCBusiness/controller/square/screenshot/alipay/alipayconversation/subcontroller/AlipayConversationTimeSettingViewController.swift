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
    var timer:TimeModel?
    var isSave:Bool? = false
    var isEdit:Bool?
    var textField:UITextField?
    var textFieldStr:String?
    var acUser:AlipayConversationUser?
    var acContent:AlipayConversationContent?
    lazy var dataPicker:UIDatePicker = {
        let picker = UIDatePicker(frame: CGRect.zero)
        picker.backgroundColor = UIColor.lightGray
        picker.datePickerMode = .dateAndTime
        picker.locale = Locale(identifier: "zh_CN")
        picker.addTarget(self, action: #selector(pickerSelect(_:)), for: .valueChanged)
        return  picker
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
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
        self.view.addSubview(self.dataPicker)
        self.dataPicker.snp.makeConstraints { (maker) in
            maker.left.right.bottom.equalToSuperview()
            maker.height.equalTo(200)
        }
    }
    func initTableView () -> UITableView {
        let tableView = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT-64), style: .grouped)
        tableView.backgroundColor = UIColor.clear
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(AlipayConversationSettingTextFieldCell.self, forCellReuseIdentifier: "textFieldCell")
        tableView.register(AlipayConversationSettingTimeButtonCell.self, forCellReuseIdentifier: "timerBtnCell")
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(tableViewTap))
        tableView.addGestureRecognizer(tap)
        return tableView
    }
    func tableViewTap () {
        self.textField?.resignFirstResponder()
    }
    func iniData () {
        if isEdit == false && self.acContent == nil{
            let now = Date()
            let tempString = "{\"timerType\":0,\"timer\":\"\(now.getStringDateFrom12())\",\"time\":\(now.timeIntervalSince1970)}"
            self.timer =  TimeModel(JSONString: tempString)
            let realm = try! Realm()
            self.acContent = AlipayConversationContent()
            self.acContent?.id = UUID().uuidString
            self.acContent?.index = self.index!
            self.acContent?.type = "时间"
            self.acContent?.content = (self.timer?.toJSONString())!
            self.acContent?.user = self.acUser
            self.acContent?.contentSender = nil
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
        self.timer?.timer = self.textField?.text
        self.isSave = true
        let realm = try! Realm()
        if self.isEdit == false {
            self.acContent?.content = (self.timer?.toJSONString())!
            try! realm.write {
                realm.create(AlipayConversationContent.self, value: self.acContent as Any, update: true)
            }
        } else {
            try! realm.write {
                self.acContent?.content = (self.timer?.toJSONString())!
            }
        }
        self.navigationController?.popViewController(animated: true)
    }
    @objc func  pickerSelect(_ picker:UIDatePicker){
        if self.timer?.timerType == 0{
            self.timer?.timer =  picker.date.getStringDateFrom12()
            self.timer?.time = picker.date.timeIntervalSince1970
        }else{
            self.timer?.timer =  picker.date.getStringDateFrom24()
            self.timer?.time = picker.date.timeIntervalSince1970
        }
        self.tableView.reloadData()
    }
}
extension AlipayConversationTimeSettingViewController:UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
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
            textFieldCell.textField?.text = self.timer?.timer
            textFieldCell.textField?.font = UIFont.systemFont(ofSize: 15)
            textFieldCell.textField?.backgroundColor = UIColor.white
            textFieldCell.textField?.textAlignment = .center
            textFieldCell.textField?.borderStyle = .none
            textFieldCell.textField?.placeholder = ""
            textFieldCell.textField?.delegate = self
            self.textField = textFieldCell.textField
            return textFieldCell
        }else{
            let timerBtnCell = tableView.dequeueReusableCell(withIdentifier: "timerBtnCell") as! AlipayConversationSettingTimeButtonCell
            timerBtnCell.block = {
                [unowned self] in
                self.tableView.reloadData()
            }
            timerBtnCell.configer(self.timer!)
            timerBtnCell.selectionStyle = .none
            return timerBtnCell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
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

