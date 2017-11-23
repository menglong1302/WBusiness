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
    var flag = false
    var conversationType:ConversationType = .privateChat{
        didSet{
            switch conversationType {
            case .groupChat:
                self.selectView.dataArray.remove(at: 7)
                self.selectView.dataArray.remove(at: 4)

                self.navigationItem.title = "微信群聊"
                break
            default:
                self.selectView.dataArray.remove(at: 7)

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
    lazy var contents = List<WXContentEntity>()
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        self.fetchData()
        self.tableView.reloadData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard !flag else {
                self.fetchData()
                self.tableView.reloadData()
            return 
        }
        flag = true
        
 
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
                 self.getConversation()
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
                 self.getConversation()
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
    func getConversation(){
        self.contents.removeAll()
        let realm = try! Realm()
        let predicate = NSPredicate(format: "parent.id = %@", self.conversation.id)
        let results = realm.objects(WXContentEntity.self).filter(predicate).sorted(byKeyPath: "index")
        for result in results {
            self.contents.append(result)
        }
    }
    
    func makeTableView() -> YLTableView {
        let tableView = YLTableView(frame: CGRect.zero)
        tableView.backgroundColor = UIColor.rgbq(r: 238, g: 236, b: 243, a: 1)
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.ylDelegate = self
        tableView.ylDataSource = self
        tableView.contentInset = UIEdgeInsetsMake(0, 0, 10, 0)
        tableView.separatorStyle = .singleLine
        tableView.isArrowCrossSection = false
        tableView.register(PeopleTableViewCell.self, forCellReuseIdentifier: "peopleCellId")
        tableView.register(WXConversationTableViewCell.self, forCellReuseIdentifier: "WXConversationCellId")
        
        tableView.onlyChangeSelectIndexPath = IndexPath(row: 0, section: 1)
        //设置分割线内边距
        
        tableView.separatorStyle = .none
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
        btn.addTarget(self, action: #selector(previewClick), for: .touchUpInside)
        return btn
    }
    func previewClick(){
        let vc = WXChatViewController()
        vc.contents = self.contents
        vc.conversation = self.conversation
        present( WXBaseNavigationViewController(rootViewController: vc), animated: true, completion: nil)
    }
    func addConversationBtnClick()  {
        
        guard   self.conversation.receivers.count != 0 else {
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
            return
        }
        
        
        UIApplication.shared.keyWindow?.addSubview(selectView)
        selectView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.3, delay: 0, options: UIViewAnimationOptions.curveEaseInOut, animations: {
            self.selectView.containerView?.frame = CGRect.init(x:0,y:0,width:SCREEN_WIDTH,height:SCREEN_HEIGHT)
            self.selectView.backgroundColor = UIColor.rgbq(r: 0, g: 0, b: 0, a: 0.3)
        }, completion: nil)
        selectView.indexRowBlock = {
            (index) in
            switch index {
            case 0:
                let vc = FileSetingViewController()
                vc.contentEnumType = .WeChat
                vc.conversation = self.conversation
                vc.conversationType = self.conversationType
                vc.block = {
                    self.tableView.reloadData()
                }
                self.navigationController?.pushViewController(vc, animated: true)
                break
            case 1:
                let vc = ImageSetingViewController()
                vc.contentEnumType = .WeChat
                vc.conversation = self.conversation
                vc.conversationType = self.conversationType
                vc.block = {
                    self.tableView.reloadData()
                }
                self.navigationController?.pushViewController(vc, animated: true)
                break
            case 2:
                
                let vc =  WXAudioSetingViewController()
                vc.contentEnumType = .WeChat
                vc.conversation = self.conversation
                vc.conversationType = self.conversationType
                vc.block = {
                    self.tableView.reloadData()
                }
                self.navigationController?.pushViewController(vc, animated: true)
                break
            case 3:
                let vc =  WXRedPacketViewController()
                vc.contentEnumType = .WeChat
                vc.conversation = self.conversation
                vc.conversationType = self.conversationType
                vc.block = {
                    self.tableView.reloadData()
                }
                self.navigationController?.pushViewController(vc, animated: true)
                break
                
            case 4:
                if self.conversationType == .privateChat{
                    let vc =  WXTransferAccountsViewController()
                    vc.conversation = self.conversation
                    vc.conversationType = self.conversationType
                    vc.block = {
                        self.tableView.reloadData()
                    }
                    self.navigationController?.pushViewController(vc, animated: true)
                    break
                }else{//群聊 4：时间
                    
                    let vc =  WXTimeViewController()
                    vc.conversation = self.conversation
                    vc.conversationType = self.conversationType
                    vc.block = {
                        self.tableView.reloadData()
                    }
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                break
            case 5:
                if self.conversationType == .privateChat{
                    let vc =  WXTimeViewController()
                    vc.conversation = self.conversation
                    vc.conversationType = self.conversationType
                    vc.block = {
                        self.tableView.reloadData()
                    }
                    self.navigationController?.pushViewController(vc, animated: true)
                }else{
                    let vc =  WXPromptViewController()
                    vc.conversation = self.conversation
                    vc.conversationType = self.conversationType
                    vc.block = {
                        self.tableView.reloadData()
                    }
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                break
            case 6:
                let vc =  WXPromptViewController()
                vc.conversation = self.conversation
                vc.conversationType = self.conversationType
                vc.block = {
                    self.tableView.reloadData()
                }
                self.navigationController?.pushViewController(vc, animated: true)
                break
            case 7:
                break
            default: break
                
            }
            
        }
        
    }
    
}

extension WXConversationViewController:UITableViewDelegate,UITableViewDataSource,YLTableViewDelegate,YLTableViewDataSource{
    
    func dataSourceArrayInTableView(_ tableView: YLTableView) -> Array<AnyObject> {
        
        var array = Array<AnyObject>()
        for entity in contents{
            array.append(entity)
        }
        return array
    }
 
    
    func tableView(_ tableView: YLTableView, newDataSourceArrayAfterMove newDataSourceArray: Array<AnyObject>) {
        contents.removeAll()
        for entity in newDataSourceArray {
            contents.append(entity as! WXContentEntity)
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()

        }
        
         DispatchQueue.main.async{
            let realm = try! Realm()
            var index = 0
            try! realm.write{
                for entity in newDataSourceArray{
                  let model =   entity as! WXContentEntity
                    model.index = index
                    index += 1
                }
            }
        }
        
    }
    func tableView(_ tableView: YLTableView, canMoveYlForIndexPath indexPath: IndexPath) -> Bool {
        if indexPath.section == 0{
            return false
        }else{
            return true
        }
    }
    
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
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "WXConversationCellId") as! WXConversationTableViewCell
            let content = contents[indexPath.row]
            cell.configer(content)
              return cell
        }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }else{
            return contents.count
        }
       
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0 {
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
        }else{
            let wxContentEntity = self.contents[indexPath.row]
            switch wxContentEntity.contentType{
            case  1:
                let vc = FileSetingViewController()
                vc.type = .Edit
                vc.contentEnumType = .WeChat
                vc.conversation = self.conversation
                vc.conversationType = self.conversationType
                vc.contentEntity = wxContentEntity
                vc.block = {
                    self.tableView.reloadData()
                }
                self.navigationController?.pushViewController(vc, animated: true)
                break
            case 2:
                let vc = ImageSetingViewController()
                vc.type = .Edit
                vc.contentEnumType = .WeChat
                vc.conversation = self.conversation
                vc.conversationType = self.conversationType
                vc.contentEntity = wxContentEntity
                vc.block = {
                    self.tableView.reloadData()
                }
                self.navigationController?.pushViewController(vc, animated: true)
                break
             case 3:
                
                let vc = WXAudioSetingViewController()
                vc.type = .Edit
                vc.contentEnumType = .WeChat
                vc.conversation = self.conversation
                vc.conversationType = self.conversationType
                vc.contentEntity = wxContentEntity
                vc.block = {
                    self.tableView.reloadData()
                }
                self.navigationController?.pushViewController(vc, animated: true)
                
                break
            case 4:
                let vc = WXRedPacketViewController()
                vc.type = .Edit
                vc.contentEnumType = .WeChat
                vc.conversation = self.conversation
                vc.conversationType = self.conversationType
                vc.contentEntity = wxContentEntity
                vc.block = {
                    self.tableView.reloadData()
                }
                self.navigationController?.pushViewController(vc, animated: true)
                break
            case 5:
                let vc = WXTransferAccountsViewController()
                vc.type = .Edit
                vc.conversation = self.conversation
                vc.conversationType = self.conversationType
                vc.contentEntity = wxContentEntity
                vc.block = {
                    self.tableView.reloadData()
                }
                self.navigationController?.pushViewController(vc, animated: true)
                break
            case 6:
                let vc = WXTimeViewController()
                vc.type = .Edit
                vc.conversation = self.conversation
                vc.conversationType = self.conversationType
                vc.contentEntity = wxContentEntity
                vc.block = {
                    self.tableView.reloadData()
                }
                self.navigationController?.pushViewController(vc, animated: true)
                break
                
            case 7:
                let vc = WXPromptViewController()
                vc.type = .Edit
                vc.conversation = self.conversation
                vc.conversationType = self.conversationType
                vc.contentEntity = wxContentEntity
                vc.block = {
                    self.tableView.reloadData()
                }
                self.navigationController?.pushViewController(vc, animated: true)
                
                break
            default:
                break
            }
           
        }
        
        
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == 0{
            return false
            
        }
        return true
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let model =  contents[indexPath.row]
            contents.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.left)
            let realm = try! Realm()
            try! realm.write {
                realm.delete(model)
            }
            
        }
    }
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "删除"
    }
}





