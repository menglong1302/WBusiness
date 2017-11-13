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
import ChameleonFramework
class WXPromptViewController: BaseViewController {
    
    var block:ContentBlock?
    var tempString:String?
    var array:[[String]] = [["撤回消息提示","加好友提示","打招呼提示","陌生人提示"  ],["邀请入群提示","扫二维码入群提示","消息撤回提示","修改群名提示","隐私安全提示" ]]
    lazy var tableView:UITableView = {
        let tableView = UITableView(frame: CGRect.zero)
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = UIColor.rgbq(r: 238, g: 236, b: 243, a: 1)
        tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0 )
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 50
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.register(WXPromptTableViewCell.self, forCellReuseIdentifier: "promptCellId")
        
        return tableView
    }()
    
    var type:ToolType?
    var conversation:WXConversation?{
        didSet{
            if type == nil || type ==  .Create {
                self.tempString = ""
                self.tableView.reloadData()
            }
        }
    }
    var conversationType:ConversationType?{
        didSet{
            initBtn(conversationType!)
        }
    }
    
    
    
    var contentEnumType:ContentEnumType?
    var contentEntity:WXContentEntity = WXContentEntity(){
        didSet{
            tempString = contentEntity.content
        }
    }
    var textView:YYTextView?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
    }
    
    func initView()  {
        
        
        self.view.backgroundColor = UIColor.rgbq(r: 238, g: 236, b: 243, a: 1)
        self.navigationItem.title = "系统提示设置"
        self.rightTitle = "保存"
        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
        
        
        self.automaticallyAdjustsScrollViewInsets = false
    }
    override func rightBtnClick(_ sender: UIButton) {
        
        guard let text = self.textView?.text,!(text.isEmpty) else {
            self.view.showImageHUDText("系统消息不能为空")
            return
        }
        
        let realm = try! Realm()
        
        try! realm.write {
            contentEntity.content = (self.textView?.text)!
            if self.type == .Create || self.type == nil{
                let entities = realm.objects(WXContentEntity.self).filter("parent.id = %@",self.conversation?.id ?? "")
                contentEntity.index = entities.count+1
                contentEntity.parent = conversation
                contentEntity.id = UUID().uuidString
                contentEntity.contentType = 7
                realm.create(WXContentEntity.self, value: contentEntity, update: false)
                
            }
        }
        if block != nil {
            block!()
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    func initBtn(_ type:ConversationType)  {
        let footerView = UIView()
        
        let k = type == .privateChat ? 100 : 200
        let count = type == .privateChat ? 4 : 5
        let arr = array[type == .privateChat ? 0 : 1]
        for index in 1...count {
            let btn = UIButton(type: .custom)
            btn.setTitleColor(UIColor.white, for: .normal)
            btn.backgroundColor = HexColor("ff6633")
            btn.layer.cornerRadius = 5
            btn.layer.masksToBounds = true
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            btn.titleLabel?.textAlignment = .center
            btn.setTitle(arr[index - 1], for: .normal)
            btn.addTarget(self, action: #selector(btnClick(_:)), for: .touchUpInside)
            btn.tag = k + index
            footerView.addSubview(btn)
             if index == count{
                btn.snp.makeConstraints({ (maker) in
                    maker.left.equalToSuperview().offset(15)
                    maker.right.equalToSuperview().offset(-15)
                    maker.height.equalTo(35).priority(999)
                    maker.top.equalToSuperview().offset(index*15+35*(index - 1))
                 })
            }else{
                btn.snp.makeConstraints({ (maker) in
                    maker.left.equalToSuperview().offset(15)
                    maker.right.equalToSuperview().offset(-15)
                    maker.height.equalTo(35)
                    maker.top.equalToSuperview().offset(index*15+35*(index - 1))
                })
            }
           
        }
        footerView.frame = CGRect(x: 0, y: 0, width: Int(SCREEN_WIDTH), height: count*40+40)
        self.tableView.tableFooterView = footerView
        
        
    }
    @objc func btnClick(_ btn:UIButton)  {
        if self.conversationType == .privateChat{
            switch btn.tag{
            case 101:
                self.tempString = "你撤回了一条消息"
                break
            case 102:
                let role =  self.conversation?.receivers[0]
                self.tempString = "你已添加了\(  (role?.nickName)!)，现在可以开始聊天了"
                break
            case 103:
                  self.tempString = "以上是打招呼的内容"
                break
            case 104:
                 self.tempString = "如果陌生人主动添加你为朋友，请谨慎合适对方身份。"
                break
                
            default: break
                
            }
           
        }else{
            let sendRole =  self.conversation?.sender
            let receiveRole =  self.conversation?.receivers[0]
            
            switch btn.tag{
            case 201:
               
                self.tempString = "\((sendRole?.nickName)!)邀请\((receiveRole?.nickName)!)加入了群聊"
                break
            case 202:
                self.tempString = "\((receiveRole?.nickName)!)通过扫描\((sendRole?.nickName)!)分享的二维码加入群聊"

                break
            case 203:
                self.tempString = "”\((sendRole?.nickName)!)“撤回了一条消息"
                break
            case 204:
                self.tempString = "你修改群名为”群聊“"

                break
            case 205:
                 self.tempString = "\((receiveRole?.nickName)!)与群里其他人都不是微信朋友关系，请注意隐私安全"
                break
            default: break
                
            }
        }
         self.tableView.reloadData()
    }
}
extension WXPromptViewController:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "promptCellId") as! WXPromptTableViewCell
        cell.textView.text = self.tempString
        self.textView = cell.textView
        cell.selectionStyle = .none
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
    }
    
}





