//
//  AlipayConversationImageSettingViewController.swift
//  WCBusiness
//
//  Created by Ray on 2017/10/27.
//  Copyright © 2017年 LYL. All rights reserved.
//

import UIKit
import SnapKit
import RealmSwift
import PGActionSheet

class AlipayConversationImageSettingViewController : BaseViewController {
    lazy var tableView = self.initTableView()
    var sender:Role?
    var receiver:Role?
    var selectRole:Role?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "图片设置"
        self.view.backgroundColor = UIColor.init(hexString: "EFEFF4")
        self.initView()
        self.initRightNavBarBtn()
        self.selectRole = self.sender
    }
    func initView () {
        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints({(maker) in
            maker.edges.equalToSuperview()
        })
        
    }
    func initTableView() -> UITableView {
        let tableView = UITableView(frame:CGRect.zero)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.clear
        tableView.register(AlipayConversationSettingCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }
    func initRightNavBarBtn() {
        let rightBtn = UIButton.init(frame:CGRect.zero)
        rightBtn.setTitle("保存", for: .normal)
        rightBtn.addTarget(self,action:#selector(rightItemBtnAction), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: rightBtn)
    }
    func rightItemBtnAction() {
        print("rightItemBtnAction")
    }
}

extension AlipayConversationImageSettingViewController:UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! AlipayConversationSettingCell
        if indexPath.section == 0 && indexPath.row == 0 {
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
            
        } else {
            cell.setData(["title":"选择照片","name":"","imageName":""])
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
