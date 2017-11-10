//
//  AlipayConversationSystemMessageSettingViewController.swift
//  WCBusiness
//
//  Created by Ray on 2017/11/9.
//  Copyright © 2017年 LYL. All rights reserved.
//

import UIKit
import SnapKit
import RealmSwift

class AlipayConversationSystemMessageSettingViewController: BaseViewController {
    var textView:UITextView?
    var withdrawMessageBtn:UIButton?
    var addFriendMessageBtn:UIButton?
    var acUser:AlipayConversationUser?
    var acContent:AlipayConversationContent?
    var index:Int!
    var isSave:Bool? = false
    var friend:Role?
    var isEdit:Bool?
    var textViewStr:String? = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "系统提示设置"
        self.view.backgroundColor = UIColor.init(hexString: "EFEFF4")
        if self.isEdit == true {
            self.textViewStr = self.acContent?.content
        }
        self.initView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.iniData()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.textView?.resignFirstResponder()
        let realm = try! Realm()
        if self.isEdit == false && self.isSave == false {
            let acContent = realm.object(ofType: AlipayConversationContent.self, forPrimaryKey: self.acContent?.id)
            try! realm.write {
                realm.delete(acContent!)
            }
        }
    }
    func initView () {
        let button = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 30, height: 30))
        button.setTitle("保存", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.addTarget(self, action: #selector(rightBtnAction), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: button)
        
        self.textView = UITextView.init(frame: CGRect.zero)
        self.view.addSubview(self.textView!)
        self.textView?.text = self.textViewStr
        self.textView?.returnKeyType = UIReturnKeyType.done
        self.textView?.font = UIFont.systemFont(ofSize: 15)
        self.textView?.delegate = self
        self.textView?.snp.makeConstraints({ (maker) in
            maker.top.equalToSuperview().offset(10)
            maker.left.right.equalToSuperview()
            maker.height.equalTo(100)
        })
        self.withdrawMessageBtn = UIButton.init(frame: CGRect.zero)
        self.view.addSubview(self.withdrawMessageBtn!)
        self.withdrawMessageBtn?.layer.cornerRadius = 5
        self.withdrawMessageBtn?.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        self.withdrawMessageBtn?.setTitle("撤回消息提示", for: .normal)
        self.withdrawMessageBtn?.setTitleColor(UIColor.white, for: .normal)
        self.withdrawMessageBtn?.backgroundColor = UIColor.init(hexString: "1BA5EA")
        self.withdrawMessageBtn?.addTarget(self, action: #selector(withdrawMessageBtnAction), for: .touchUpInside)
        self.withdrawMessageBtn?.snp.makeConstraints({ (maker) in
            maker.top.equalTo((self.textView?.snp.bottom)!).offset(15)
            maker.left.right.equalToSuperview().offset(15)
            maker.right.equalToSuperview().offset(-15)
            maker.height.equalTo(40)
        })
        self.addFriendMessageBtn = UIButton.init(frame: CGRect.zero)
        self.view.addSubview(self.addFriendMessageBtn!)
        self.addFriendMessageBtn?.layer.cornerRadius = 5
        self.addFriendMessageBtn?.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        self.addFriendMessageBtn?.setTitle("加好友提示", for: .normal)
        self.addFriendMessageBtn?.setTitleColor(UIColor.white, for: .normal)
        self.addFriendMessageBtn?.backgroundColor = UIColor.init(hexString: "1BA5EA")
        self.addFriendMessageBtn?.addTarget(self, action: #selector(addFriendMessageBtnAction), for: .touchUpInside)
        self.addFriendMessageBtn?.snp.makeConstraints({ (maker) in
            maker.top.equalTo((self.withdrawMessageBtn?.snp.bottom)!).offset(15)
            maker.left.right.equalToSuperview().offset(15)
            maker.right.equalToSuperview().offset(-15)
            maker.height.equalTo(40)
        })
    }
    func iniData () {
        if isEdit == false && self.acContent == nil{
            let realm = try! Realm()
            self.acContent = AlipayConversationContent()
            self.acContent?.id = UUID().uuidString
            self.acContent?.index = self.index!
            self.acContent?.type = "系统提示"
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
        self.textView?.resignFirstResponder()
        self.isSave = true
        self.textViewStr = self.textView?.text
        let realm = try! Realm()
        if self.isEdit == false {
            self.acContent?.content = self.textViewStr!
            try! realm.write {
                realm.create(AlipayConversationContent.self, value: self.acContent as Any, update: true)
            }
        } else {
            try! realm.write {
                self.acContent?.content = self.textViewStr!
            }
        }
        self.navigationController?.popViewController(animated: true)
    }
    func withdrawMessageBtnAction () {
        self.textView?.text = "你撤回了一条消息"
    }
    func addFriendMessageBtnAction () {
        self.textView?.text = "你已经添加了\(self.acUser?.receiver?.nickName ?? "")，现在可以开始聊天了。"
    }
}
extension AlipayConversationSystemMessageSettingViewController:UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        self.textViewStr = textView.text
        textView.resignFirstResponder()
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text.contains("\n") {
            self.view.endEditing(true)
            return false
        }
        return true
    }
}

