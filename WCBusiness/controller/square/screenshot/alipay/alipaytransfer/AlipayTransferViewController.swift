//
//  AlipayTransferViewController.swift
//  WCBusiness
//
//  Created by Ray on 2017/11/16.
//  Copyright © 2017年 LYL. All rights reserved.
//

import UIKit
import SnapKit
import RealmSwift

class AlipayTransferViewController: BaseViewController {
    lazy var tableView = self.makeTableView()
    lazy var tableFooterView = self.makeTableFooterView()
    var selectRole:Role?
    var acUser:AlipayConversationUser?
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initData()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    func initView () {
        self.title = "支付宝转账"
        self.view.backgroundColor = UIColor.init(hexString: "EFEFF4")
        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
    }
    func initData () {
        let realm = try! Realm()
        
        if let alipayConversationUser = realm.objects(AlipayConversationUser.self).first{
            self.acUser = alipayConversationUser
            self.selectRole = self.acUser?.sender
        } else {
            let acsvc = AlipayConversationSettingViewController()
            self.navigationController?.pushViewController(acsvc, animated: true)
        }
        
    }
    func makeTableView() -> UITableView {
        let tableView = UITableView.init(frame: CGRect.zero, style: .plain)
        tableView.backgroundColor = UIColor.init(hexString: "EFEFF4")
//        tableView.footerView(forSection: 2)
        tableView.tableFooterView = tableFooterView
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(AlipayConversationSettingCell.self, forCellReuseIdentifier: "cell")
        tableView.register(AlipayTransferViewControllerCell.self, forCellReuseIdentifier: "atvcCell")
        return tableView
    }
    func makeTableFooterView () -> UIView {
        let footerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: 80))
        let footerButton = UIButton.init(frame: CGRect.zero)
        footerView.addSubview(footerButton)
        footerButton.setTitle("生成预览", for: .normal)
        footerButton.layer.cornerRadius = 5
        footerButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        footerButton.setTitleColor(UIColor.white, for: .normal)
        footerButton.backgroundColor = UIColor.init(hexString:"1BA5EA")
        footerButton.snp.makeConstraints { (maker) in
            maker.edges.equalTo(footerView).inset(UIEdgeInsetsMake(20, 15, 20, 15))
        }
        return footerView
    }
}
extension AlipayTransferViewController:UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 1 || section == 2 {
            return 4
        } else {
            return 0
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
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
        }
//        else if indexPath.section == 1 {
//            if indexPath.row == 0 {
//                
//            } else {
//                
//            }
//        }
        else if indexPath.section == 2 {
            let atvcCell = tableView.dequeueReusableCell(withIdentifier: "atvcCell", for: indexPath) as! AlipayTransferViewControllerCell
            atvcCell.setData(["title" : "付款方式","name" : "无"])
            atvcCell.selectionStyle = .none
            return atvcCell
        }
        return UITableViewCell()
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
//                self.acContent?.contentSender = self.selectRole
            }
            self.tableView.reloadData()
        }
    }
}
