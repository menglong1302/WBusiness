//
//  FileSetingViewController.swift
//  WCBusiness
//
//  Created by YangXL on 2017/10/30.
//  Copyright © 2017年 LYL. All rights reserved.
//


import YYText
import RealmSwift
import PGActionSheet
class WXTransferAccountsViewController: BaseViewController {
    
    var block:ContentBlock?
    var tempString:String?
    var tempRole:Role?
    lazy var tableView:UITableView = {
        let tableView = UITableView(frame: CGRect.zero)
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = UIColor.rgbq(r: 238, g: 236, b: 243, a: 1)
        tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0 )
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 50
        tableView.rowHeight = UITableViewAutomaticDimension
        
        tableView.register(WXRedPacketContentTableViewCell.self, forCellReuseIdentifier: "contentCellId")
        tableView.register(WXTransferAccountTypeTableViewCell.self, forCellReuseIdentifier: "transferTypeCellId")
        tableView.register(ChatSettingTableViewCell.self, forCellReuseIdentifier: "chatSettingCellId")
        tableView.register(ChangeRoleTableViewCell.self, forCellReuseIdentifier: "roleCellId")
        return tableView
    }()
    var type:ToolType?
    var transfer:TransferAccountsModel?
    var textView:YYTextView?
    var illustrationTextView:YYTextView?
    var conversation:WXConversation?{
        didSet{
            if type == nil || type ==  .Create {
                tempRole = conversation?.sender
                self.tempString = "{\"transferType\":0,\"transferAmount\":\"\",\"illustration\":\"\",\"isGetted\":false}"
                transfer =  TransferAccountsModel(JSONString: self.tempString!)
                self.tableView.reloadData()
            }
        }
    }
    var conversationType:ConversationType? //只是单聊
    
    var contentEntity:WXContentEntity = WXContentEntity(){
        didSet{
            tempString = contentEntity.content
            transfer =  TransferAccountsModel(JSONString: self.tempString!)
            tempRole = contentEntity.sender
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
    }
    
    func initView()  {
        
        
        self.view.backgroundColor = UIColor.rgbq(r: 238, g: 236, b: 243, a: 1)
        self.navigationItem.title = "转账设置"
        self.rightTitle = "保存"
        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
        
        self.automaticallyAdjustsScrollViewInsets = false
    }
    override func rightBtnClick(_ sender: UIButton) {
        
        guard  let text = self.textView?.text,!(text.isEmpty) else {
            self.view.showImageHUDText("金额不能为空！")
            return
        }
        self.transfer?.transferAmount = self.textView?.text
        self.transfer?.illustration = self.illustrationTextView?.text
        
        let realm = try! Realm()
        
        try! realm.write {
            contentEntity.content = (self.transfer?.toJSONString())!
            contentEntity.sender = tempRole
            if self.type == .Create || self.type == nil{
                let entities = realm.objects(WXContentEntity.self).filter("parent.id = %@",self.conversation?.id ?? "")
                contentEntity.index = entities.count+1
                contentEntity.parent = conversation
                contentEntity.id = UUID().uuidString
                contentEntity.contentType = 5
                realm.create(WXContentEntity.self, value: contentEntity, update: false)
                
            }
        }
        if block != nil {
            block!()
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    
}
extension WXTransferAccountsViewController:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        if self.transfer?.transferType == 0{
            return 4
        }
        return 2
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "roleCellId") as! ChangeRoleTableViewCell
        
        if indexPath.section == 0 {
            cell.hintLabel.text = "选择发送人"
            if let role = tempRole{
                cell.nickNameLabel.text = role.nickName
                if role.isDiskImage{
                    cell.portraitIcon.kf.setImage(with:URL(fileURLWithPath: role.imageUrl.localPath()))
                }else{
                    cell.portraitIcon.image = UIImage(named: role.imageName)
                }
            }
            cell.accessoryType = .disclosureIndicator
            
        }else if indexPath.section == 1{
            if indexPath.row == 0{
                let cell = tableView.dequeueReusableCell(withIdentifier: "transferTypeCellId") as! WXTransferAccountTypeTableViewCell
                cell.hintLabel.text = "选择类型"
                cell.configer(self.transfer!)
                cell.block = {
                    [unowned self] in
                    self.tableView.reloadData()
                }
                return cell
            }else if indexPath.row == 1{
                let cell = tableView.dequeueReusableCell(withIdentifier: "contentCellId") as! WXRedPacketContentTableViewCell
                self.textView = cell.textView
                cell.textView.placeholderText = "请输入转账金额（必填）"
                cell.textView.text = self.transfer?.transferAmount
                return cell
            }else if indexPath.row == 2{
                let cell = tableView.dequeueReusableCell(withIdentifier: "contentCellId") as! WXRedPacketContentTableViewCell
                self.illustrationTextView = cell.textView
                cell.textView.placeholderText = "请输入转账说明（选项）"
                cell.textView.text = self.transfer?.illustration
                return cell
            }else if indexPath.row == 3{
                let settingCell = tableView.dequeueReusableCell(withIdentifier: "chatSettingCellId") as! ChatSettingTableViewCell
                settingCell.selectionStyle = .none
                settingCell.hintLabel.text = "是否已领取"
                settingCell.numLabel.text = ""
                settingCell.numLabel.isHidden = true
                settingCell.swichBar.isHidden = false
                settingCell.swichBar.tag = 100
                settingCell.swichBar.addTarget(self, action: #selector(switchAction(_:)), for:.valueChanged)
                settingCell.accessoryType = .none
                if (self.transfer?.isGetted)!{
                    settingCell.swichBar.isOn = true
                }else{
                    settingCell.swichBar.isOn = false
                }
                return settingCell
            }
            
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 0{
            if self.conversationType == .privateChat{
                tempRole = tempRole == self.conversation?.sender ? self.conversation?.receivers[0] : self.conversation?.sender
                self.tableView.reloadRows(at: [IndexPath.init(row: 0, section: 0)], with: .none)
            }else{
                let vc = SenderPeopleSelectViewController()
                vc.conversation = conversation
                vc.block = {
                    [unowned self]  (role) in
                    self.tempRole = role
                    self.tableView.reloadRows(at: [IndexPath.init(row: 0, section: 0)], with: .none)
                }
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }else{
            
            
        }
        
    }
    @objc func switchAction(_ swt:UISwitch) {
        self.transfer?.isGetted = (self.transfer?.isGetted!)! ? false:true
     }
}



