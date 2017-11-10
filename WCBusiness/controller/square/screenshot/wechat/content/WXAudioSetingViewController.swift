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
class WXAudioSetingViewController: BaseViewController {
    
    var array = [EmojiModel]()
    var block:ContentBlock?
    var emojiMapper = [String:UIImage]()
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
        
        tableView.register(WXAudioTableViewCell.self, forCellReuseIdentifier: "audioCellId")

        tableView.register(ChangeRoleTableViewCell.self, forCellReuseIdentifier: "roleCellId")
        return tableView
    }()
    var type:ToolType?
    var conversation:WXConversation?{
        didSet{
            if type == nil || type ==  .Create {
                tempRole = conversation?.sender
                self.tempString = "0"
                self.tableView.reloadData()
            }
        }
    }
    var conversationType:ConversationType?
    var contentEnumType:ContentEnumType?
    
    var contentEntity:WXContentEntity = WXContentEntity(){
        didSet{
            tempString = contentEntity.content
            tempRole = contentEntity.sender
        }
    }
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
    }
   
    func initView()  {
        
        
        self.view.backgroundColor = UIColor.rgbq(r: 238, g: 236, b: 243, a: 1)
        self.navigationItem.title = "语音设置"
        self.rightTitle = "保存"
        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
        
        self.automaticallyAdjustsScrollViewInsets = false
    }
    override func rightBtnClick(_ sender: UIButton) {
        
        
        let realm = try! Realm()
        
        try! realm.write {
            contentEntity.content = self.tempString!
            contentEntity.sender = tempRole
            if self.type == .Create || self.type == nil{
                let entities = realm.objects(WXContentEntity.self).filter("parent.id = %@",self.conversation?.id ?? "")
                contentEntity.index = entities.count+1
                contentEntity.parent = conversation
                contentEntity.id = UUID().uuidString
                contentEntity.contentType = 3
                realm.create(WXContentEntity.self, value: contentEntity, update: false)
                
            }
        }
        if block != nil {
            block!()
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    
}
extension WXAudioSetingViewController:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
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
            let audioCell = tableView.dequeueReusableCell(withIdentifier: "audioCellId") as! WXAudioTableViewCell
            audioCell.hintLabel.text = "语音时间"
            audioCell.tintLabel.text = self.tempString
            
            audioCell.sliderBar.setValue(Float(Double(self.tempString!)!), animated: true)
            audioCell.sliderBar.addTarget(self, action: #selector(sliderBarChange(_:)), for: UIControlEvents.valueChanged)
            return audioCell
  
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
    @objc func sliderBarChange(_ slider:UISlider){
        self.tempString = String(Int(slider.value))
        let audioCell =  self.tableView.cellForRow(at: IndexPath(item: 0, section: 1)) as! WXAudioTableViewCell
        audioCell.tintLabel.text = self.tempString
    }
}



