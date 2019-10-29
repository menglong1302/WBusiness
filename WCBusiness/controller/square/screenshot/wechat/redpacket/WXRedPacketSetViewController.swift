//
//  WXRedPacketSetViewController.swift
//  WCBusiness
//
//  Created by YangXL on 2017/11/27.
//  Copyright © 2017年 LYL. All rights reserved.
//

import Foundation
import YYText
import ChameleonFramework
class WXRedPacketSetViewController:BaseViewController{
    lazy var tableView:UITableView = self.makeTableView()
    lazy var footerBtn:UIButton = self.makeFooterView()
    var tempRole:Role?
    var amountView:YYTextView?
    var describeView:YYTextView?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "收取红包设置"
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
        let footerView = UIView()
        footerView.addSubview(footerBtn)
        tableView.tableFooterView = footerView
        
        footerView.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 44)
        self.footerBtn.snp.makeConstraints { (maker) in
            maker.left.equalToSuperview().offset(10)
            maker.right.equalToSuperview().offset(-15)
            maker.height.equalTo(44)
        }
    }
    func makeTableView() -> UITableView {
        let tableView = UITableView(frame: CGRect.zero)
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = UIColor.rgbq(r: 238, g: 236, b: 243, a: 1)
        tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0 )
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInset = UIEdgeInsetsMake(10, 0, 0, 0)
        tableView.estimatedRowHeight = 50
        tableView.rowHeight = UITableViewAutomaticDimension
        
        tableView.register(ChangeRoleTableViewCell.self, forCellReuseIdentifier: "roleCellId")
        tableView.register(WXRedPacketContentTableViewCell.self, forCellReuseIdentifier: "contentCellId")
        
        return tableView
    }
    func makeFooterView() -> UIButton {
        let btn = UIButton()
        btn.setTitle("生成预览", for: .normal)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.backgroundColor = HexColor("ff6633")
        btn.layer.cornerRadius = 3
        btn.layer.masksToBounds = true
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        btn.addTarget(self, action: #selector(generate(_:)), for: .touchUpInside)
        return btn
    }
    @objc func generate(_ btn:UIButton)  {
        guard let text =  self.amountView?.text ,!(text.isEmpty) else{
            self.view.showImageHUDText("红包金额不能为空，请输入金额")
            return
        }
        guard let _ = self.tempRole else {
            self.view.showImageHUDText("角色不能为空，请选择角色")
            return
        }
        var model:WXRedPacketSetModel = WXRedPacketSetModel()
        
        model.role = self.tempRole
        if let text =  self.amountView?.text{
            guard text.isPurnFloat() else{
                self.view.showImageHUDText("红包金额只能是数字")
                return
            }
            if Double(text)! > 200.00 || Double(text)! < 0.00{
                self.view.showImageHUDText("红包金额只能小于等于200大于0")
                return
            }
            model.amount =  String(format: "%.2f", Double(text)!)
            
        }
         if let text = self.describeView?.text ,!(text.isEmpty){
            model.describe = text
        }else{
            model.describe = "恭喜发财，大吉大利"
        }
        let vc = WXRedPacketPreviewViewController()
        vc.model = model
        present(UINavigationController(rootViewController: vc), animated: true, completion: nil)
    }
}

extension WXRedPacketSetViewController:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "roleCellId") as! ChangeRoleTableViewCell
            cell.hintLabel.text = "选择收红包人"
            if let role = tempRole{
                cell.nickNameLabel.text = role.nickName
                if role.isDiskImage{
                    cell.portraitIcon.kf.setImage(with:URL(fileURLWithPath: role.imageUrl.localPath()))
                }else{
                    cell.portraitIcon.image = UIImage(named: role.imageName)
                }
            }
            cell.accessoryType = .disclosureIndicator
            return cell
        }else{
            if indexPath.row == 0{
                let cell = tableView.dequeueReusableCell(withIdentifier: "contentCellId") as! WXRedPacketContentTableViewCell
                self.amountView = cell.textView
                self.amountView?.keyboardType = .decimalPad
                cell.textView.placeholderText = "请输入红包金额（必填）"
                cell.selectionStyle = .none
                return cell
            }else if indexPath.row == 1{
                let cell = tableView.dequeueReusableCell(withIdentifier: "contentCellId") as! WXRedPacketContentTableViewCell
                self.describeView = cell.textView
                cell.textView.placeholderText = "请输入红包说明（选项）"
                cell.selectionStyle = .none
                return cell
            }
        }
        
        return UITableViewCell.init()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0 && indexPath.row == 0{
            let vc = RoleViewController()
            vc.operatorType = .Select
            
            vc.roleSelectBlock = {
                (role) in
                self.tempRole = role
                self.tableView.reloadData()
                
                
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 1
        }else{
            return 2
        }
    }
}
