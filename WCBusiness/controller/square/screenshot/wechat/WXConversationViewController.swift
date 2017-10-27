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
import RealmSwift
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
    let selectView:AlipayConversationAddView = {
        () in
        let view = AlipayConversationAddView()
        return  view
    }()
    
    lazy var conversation = WXConversation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
        self.tableView.reloadData()
    }
    func initView()  {
        
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
    
    func fetchData(){
        let realm = try! Realm()
        
        if self.conversationType == .privateChat {
            if let conv = realm.objects(WXConversation.self).filter("conversationType = 1").first{
                conversation = conv
            }else{
                conversation.id = UUID().uuidString
                try! realm.write {
                    realm.create(WXConversation.self, value: conversation, update: false)
                }
                fetchData()
            }
        }else{
            if let conv = realm.objects(WXConversation.self).filter("conversationType = 2").first{
                conversation = conv
            }else{
                conversation.id = UUID().uuidString
                conversation.conversationType = 2
                try! realm.write {
                    realm.create(WXConversation.self, value: conversation, update: false)
                }
                fetchData()
            }
            
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
        btn.addTarget(self, action: #selector(addConversationBtnClick), for: .touchUpInside)
        
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
    func addConversationBtnClick()  {
        
        UIApplication.shared.keyWindow?.addSubview(selectView)

        selectView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.5, delay: 0, options: UIViewAnimationOptions.curveEaseInOut, animations: {
            self.selectView.containerView?.frame = CGRect.init(x:0,y:0,width:SCREEN_WIDTH,height:SCREEN_HEIGHT)
            self.selectView.backgroundColor = UIColor.rgbq(r: 0, g: 0, b: 0, a: 0.3)
        }, completion: nil)
            
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
            var count:Int = 0
            if conversation.receivers.count>0{
                count = conversation.receivers.count+1
            }else if self.conversation.sender != nil{
                count = 1
            }
            cell.imageNum = count<=2 ? 2:count
            cell.confige(conversation)
            return  cell
        }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
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
            let groupVc = GroupConversationSettingViewController()
            groupVc.conversation = self.conversation
            vc = groupVc
            break
        default:
            let privateVC = PrivateConversationSettingViewController()
            privateVC.conversation = self.conversation
            vc = privateVC
            break
        }
        self.navigationController?.pushViewController(vc!, animated: true)
        
    }
}





