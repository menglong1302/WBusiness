//
//  FileSetingViewController.swift
//  WCBusiness
//
//  Created by YangXL on 2017/10/30.
//  Copyright © 2017年 LYL. All rights reserved.
//


import YYText
import RealmSwift
typealias ContentBlock  = () -> Void

class FileSetingViewController: BaseViewController {
    
    var array = [EmojiModel]()
    var block:ContentBlock?
    var emojiMapper = [String:UIImage]()
    var tempString:NSMutableAttributedString?
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
        
        tableView.register(ChangeRoleTableViewCell.self, forCellReuseIdentifier: "roleCellId")
        tableView.register(WXEmojiTableViewCell.self, forCellReuseIdentifier: "WXEmojiCellId")
        tableView.register(InputMessageContentTableViewCell.self, forCellReuseIdentifier: "InputMessageContentCellId")
        return tableView
    }()
    var type:ToolType?
    var textView:YYTextView?
    var conversation:WXConversation?{
        didSet{
            if type == nil || type ==  .Create {
                tempRole = conversation?.sender
                
                self.tableView.reloadData()
            }
        }
    }
    var conversationType:ConversationType?
    var contentEnumType:ContentEnumType?
    
    var contentEntity:WXContentEntity = WXContentEntity(){
        didSet{
            tempString = NSMutableAttributedString(string: contentEntity.content)
            tempString?.yy_font = UIFont.systemFont(ofSize: 16)
            tempRole = contentEntity.sender
        }
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
        initView()
    }
    func getData() -> Void {
        
         for index in 1...114{
            let model = EmojiModel()
 
            model.name = "Expression_"+String(index)+".png"
            model.mapperName = ":100\(index):"
            array.append(model)
            emojiMapper[model.mapperName!] = model.image
        }
    }
    func initView()  {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        
        
        self.view.backgroundColor = UIColor.rgbq(r: 238, g: 236, b: 243, a: 1)
        self.navigationItem.title = "文本设置"
        self.rightTitle = "保存"
        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
        
        self.automaticallyAdjustsScrollViewInsets = false
    }
    override func rightBtnClick(_ sender: UIButton) {
        let text = textView?.attributedText
        var string = ""
        
        text?.enumerateAttribute(YYTextBackedStringAttributeName, in: NSMakeRange(0, (text?.length)!), options:NSAttributedString.EnumerationOptions.longestEffectiveRangeNotRequired, using: { (value, range, stop ) in
            if value != nil  {
                let backed = value as! YYTextBackedString
                
                string.append(backed.string!)
            }else{
                string.append((text?.attributedSubstring(from: range).string)!)
            }
            
        })
        if string.isEmpty {
            self.view .showImageHUDText("请输入文本内容")
            return
        }
        let realm = try! Realm()
        
        try! realm.write {
            contentEntity.content = string
            contentEntity.sender = tempRole
            if self.type == .Create || self.type == nil{
                let entities = realm.objects(WXContentEntity.self).filter("parent.id = %@",self.conversation?.id ?? "")
                contentEntity.index = entities.count+1
                contentEntity.parent = conversation
                contentEntity.id = UUID().uuidString
                contentEntity.contentType = 0
                realm.create(WXContentEntity.self, value: contentEntity, update: false)
                
            }
        }
        if block != nil {
            block!()
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func keyBoardWillShow(_ noti:Notification){
        
    }
    @objc func keyBoardWillHide(_ noti:Notification){
        
    }
    
    @objc func keyboardDidHide(_ noti:Notification){
        
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
        
    }
}
extension FileSetingViewController:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "roleCellId") as! ChangeRoleTableViewCell
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
            return cell
            
        }else if indexPath.section == 2{
            let cell = tableView.dequeueReusableCell(withIdentifier: "WXEmojiCellId") as! WXEmojiTableViewCell
            cell.collectionView.delegate = self
            cell.collectionView.dataSource = self
            
            return cell
        }else if indexPath.section == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "InputMessageContentCellId") as! InputMessageContentTableViewCell
            cell.mapper = emojiMapper
            self.textView = cell.textView
            
            cell.textView.becomeFirstResponder()
            if self.tempString != nil{
                cell.textView.attributedText  = self.tempString
                self.textView?.selectedRange = NSMakeRange((self.tempString?.length)!, 0)

            }

            return cell
        }
        
        return UITableViewCell()
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
        }
        
    }
}
extension FileSetingViewController:UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        return CGSize(width: 30, height: 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.array.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "emojiCollectionCellId", for: indexPath) as! WXEmojiCollectionViewCell
        let model = array[indexPath.row]
        cell.imageView.image = model.image
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(5, 5, 5, 5)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: false)
        
        let model = array[indexPath.row]
        let location = self.textView?.selectedRange.location
        self.textView?.resignFirstResponder()
        let  str = NSMutableAttributedString(attributedString: (self.textView?.attributedText)!)
        let attr = NSMutableAttributedString.yy_attachmentString(withEmojiImage: model.image!, fontSize: 16)!
        attr.yy_setTextBackedString(YYTextBackedString.init(string: model.mapperName), range: NSMakeRange(0, attr.length))
        str.insert(attr, at: location!)
        str.yy_font = UIFont.systemFont(ofSize: 16)
        self.textView?.attributedText = str
        self.textView?.scrollRangeToVisible(NSMakeRange(location!+1, 0))
        self.textView?.selectedRange = NSMakeRange(location!+1, 0)
        
        
    }
}

