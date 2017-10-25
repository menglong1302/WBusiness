//
//  WXConversationViewController.swift
//  WCBusiness
//
//  Created by YangXL on 2017/10/25.
//  Copyright © 2017年 LYL. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

enum ConversationType {
    case privateChat
    case groupChat
}

class WXConversationViewController: BaseViewController {
    lazy var tableView = self.makeTableView()
    lazy var footerView = self.makeFooterView()
    lazy var addConversationBtn = self.makeAddConversationBtn()
    lazy var generatePreviewBtn = self.makeGeneratePreviewBtn()
    var conversationType:ConversationType = .privateChat{
        didSet{
            switch conversationType {
            case .groupChat:
                self.navigationItem.title = "微信群聊"
                break
            default:
                self.navigationItem.title = "微信单聊"
                break
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    func initView()  {

        self.navigationItem.title = "微信单聊"
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(tableView)
        self.view.addSubview(footerView)
        footerView.snp.makeConstraints { (maker) in
            maker.left.right.bottom.equalToSuperview()
            maker.height.equalTo(50)
        }
        tableView.snp.makeConstraints { (maker) in
            maker.left.right.top.equalToSuperview()
            maker.bottom.equalTo(footerView.snp.top)
        }
        [addConversationBtn,generatePreviewBtn].forEach {
            footerView.addSubview($0)
        }
        addConversationBtn.snp.makeConstraints { (maker) in
            maker.left.top.bottom.equalToSuperview()
            maker.width.equalTo(SCREEN_WIDTH/2.0)
        }
        generatePreviewBtn.snp.makeConstraints { (maker) in
            maker.right.top.bottom.equalToSuperview()
            maker.width.equalTo(SCREEN_WIDTH/2.0)
        }
    }
    
    
    
    func makeTableView() -> UITableView {
        let tableView = UITableView(frame: CGRect.zero)
        tableView.backgroundColor = UIColor.rgbq(r: 238, g: 236, b: 243, a: 1)
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(PeopleTableViewCell.self, forCellReuseIdentifier: "peopleCellId")
        
        //设置分割线内边距
        tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0)
        return tableView
    }
    
    func makeFooterView() -> UIView {
        let view = UIView()
        view.layer.shadowColor = UIColor.lightGray.cgColor
        return view
    }
    func makeAddConversationBtn() -> UIButton{
        let btn = UIButton(type: .custom)
        btn.setTitle("添加对话", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        btn.setTitleColor(UIColor.flatBlack, for: .normal)
        btn.titleLabel?.textAlignment = .center
        btn.backgroundColor = UIColor.white
        return btn
    }
    func makeGeneratePreviewBtn() -> UIButton{
        let btn = UIButton(type: .custom)
        btn.setTitle("生成预览", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.titleLabel?.textAlignment = .center
        btn.backgroundColor = UIColor.rgbq(r: 37, g: 202, b: 117, a: 1)
        return btn
    }
    
    
}

extension WXConversationViewController:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section==0 {
          let cell = tableView.dequeueReusableCell(withIdentifier: "peopleCellId") as! PeopleTableViewCell
            cell.accessoryType = .disclosureIndicator
            cell.imageNum = 2
            return  cell
        }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return 1
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        var vc:UIViewController?
        switch self.conversationType {
        case .groupChat:
            vc = GroupConversationSettingViewController()
            
            break
        default:
            vc = PrivateConversationSettingViewController()

            break
        }
        self.navigationController?.pushViewController(vc!, animated: true)
        
    }
}





