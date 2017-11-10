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
import ObjectMapper
class WXRedPacketViewController: BaseViewController {
    
    var array = [EmojiModel]()
    var block:ContentBlock?
    var emojiMapper = [String:UIImage]()
    var tempString:String?
    var tempRole:Role?
    lazy var tableView:UITableView = {
        let tableView = UITableView(frame: CGRect.zero)
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = UIColor.rgbq(r: 238, g: 236, b: 243, a: 1)
        tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0 )
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 50
        tableView.rowHeight = UITableViewAutomaticDimension
        
        tableView.register(WXRedPacketContentTableViewCell.self, forCellReuseIdentifier: "contentCellId")
        
        tableView.register(WXRedPacketTypeTableViewCell.self, forCellReuseIdentifier: "redTypeCellId")
        tableView.register(ChatSettingTableViewCell.self, forCellReuseIdentifier: "chatSettingCellId")
        
        
        tableView.register(ChangeRoleTableViewCell.self, forCellReuseIdentifier: "roleCellId")
        return tableView
    }()
    var type:ToolType?
    var redPacket:RedPacketModel?
    var textView:YYTextView?
    var conversation:WXConversation?{
        didSet{
            if type == nil || type ==  .Create {
                tempRole = conversation?.sender
                self.tempString = "{\"packetType\":\"0\",\"content\":\"\",\"receiveType\":\"0\",\"conversationType\":\"0\",\"isGetted\":false}"
                redPacket =  RedPacketModel(JSONString: self.tempString!)
                self.tableView.reloadData()
            }
        }
    }
    var conversationType:ConversationType?{
        didSet{
            if conversationType == .privateChat {
                redPacket?.conversationType = "0"
            }else{
                redPacket?.conversationType = "1"
            }
            self.tempString = redPacket?.toJSONString()!
        }
    }
    var contentEnumType:ContentEnumType?
    
    var contentEntity:WXContentEntity = WXContentEntity(){
        didSet{
            tempString = contentEntity.content
            redPacket =  RedPacketModel(JSONString: self.tempString!)
            tempRole = contentEntity.sender
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
    }
    
    func initView()  {
        
        
        self.view.backgroundColor = UIColor.rgbq(r: 238, g: 236, b: 243, a: 1)
        self.navigationItem.title = "红包设置"
        self.rightTitle = "保存"
        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
        
        self.automaticallyAdjustsScrollViewInsets = false
    }
    override func rightBtnClick(_ sender: UIButton) {
        
        if self.textView != nil{
            self.redPacket?.content = self.textView?.text
        }
        let realm = try! Realm()
        
        try! realm.write {
            
            
            
            contentEntity.content = (self.redPacket?.toJSONString())!
            contentEntity.sender = tempRole
            if self.type == .Create || self.type == nil{
                let entities = realm.objects(WXContentEntity.self).filter("parent.id = %@",self.conversation?.id ?? "")
                contentEntity.index = entities.count+1
                contentEntity.parent = conversation
                contentEntity.id = UUID().uuidString
                contentEntity.contentType = 4
                realm.create(WXContentEntity.self, value: contentEntity, update: false)
                
            }
        }
        if block != nil {
            block!()
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    
}
extension WXRedPacketViewController:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }else{
            if redPacket?.conversationType == "1"{
                return 2
            }else{
                if redPacket?.packetType == "0"{
                    return 3
                }else{
                    return 1
                }
            }
        }
     }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "roleCellId") as! ChangeRoleTableViewCell
        
        if indexPath.section == 0 {
            
            cell.hintLabel.text = "选择发送人"
            if  redPacket?.conversationType == "1" && redPacket?.packetType == "1"{ //群聊 收红包
                cell.hintLabel.text = "选择接收人"
            }
            
            
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
                let cell = tableView.dequeueReusableCell(withIdentifier: "redTypeCellId") as! WXRedPacketTypeTableViewCell
                cell.hintLabel.text = "选择类型"
                cell.configer(self.redPacket!)
                cell.type = 0
                cell.block = {
                    [unowned self] in
                    self.tableView.reloadData()
                }
                cell.selectionStyle = .none
                return cell
            }else if indexPath.row == 1{
                if self.redPacket?.conversationType == "0"{ //单聊
                    if self.redPacket?.packetType == "0"{
                        let settingCell = tableView.dequeueReusableCell(withIdentifier: "chatSettingCellId") as! ChatSettingTableViewCell
                        settingCell.selectionStyle = .none
                        settingCell.hintLabel.text = "是否已领取"
                        settingCell.numLabel.text = ""
                        settingCell.numLabel.isHidden = true
                        settingCell.swichBar.isHidden = false
                        settingCell.swichBar.tag = 100
                        settingCell.swichBar.addTarget(self, action: #selector(switchAction(_:)), for:.valueChanged)
                        settingCell.accessoryType = .none
                        if (self.redPacket?.isGetted)!{
                            settingCell.swichBar.isOn = true
                        }else{
                            settingCell.swichBar.isOn = false
                        }
                        return settingCell
                    }
                }else{//群聊
                    if self.redPacket?.packetType == "0"{
                        let cell = tableView.dequeueReusableCell(withIdentifier: "contentCellId") as! WXRedPacketContentTableViewCell
                        cell.configer(self.redPacket!)
                        self.textView = cell.textView
                        return cell
                    }else{
                        let cell = tableView.dequeueReusableCell(withIdentifier: "redTypeCellId") as! WXRedPacketTypeTableViewCell
                        cell.selectionStyle = .none

                        cell.hintLabel.text = "收红包类型"
                        cell.sendRed.setTitle("别人收我红包", for: .normal)
                        cell.receiveRed.setTitle("我收别人红包", for: .normal)
                        cell.type = 1
                        cell.configer(self.redPacket!)
                        cell.block = {
                            [unowned self] in
                            self.tableView.reloadData()
                        }
                        return cell
                    }
                }
                
            }else if indexPath.row == 2{
                let cell = tableView.dequeueReusableCell(withIdentifier: "contentCellId") as! WXRedPacketContentTableViewCell
                cell.configer(self.redPacket!)
                 self.textView = cell.textView
                return cell
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
        tableView.deselectRow(at: indexPath, animated: false)
        
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
    @objc func sliderBarChange(_ slider:UISlider){
        self.tempString = String(Int(slider.value))
        let audioCell =  self.tableView.cellForRow(at: IndexPath(item: 0, section: 1)) as! WXAudioTableViewCell
        audioCell.tintLabel.text = self.tempString
    }
    @objc func switchAction(_ swt:UISwitch) {
        self.redPacket?.isGetted = (self.redPacket?.isGetted!)! ? false:true
//        self.tableView.reloadData()
    }
}




