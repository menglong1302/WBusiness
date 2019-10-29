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
class ImageSetingViewController: BaseViewController {
    
    var array = [EmojiModel]()
    var block:ContentBlock?
    var emojiMapper = [String:UIImage]()
    var tempString:String?
    var tempRole:Role?
    let once = Once()
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
        return tableView
    }()
    var type:ToolType?
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
    var imageModel:WXImageModel?
    var contentEntity:WXContentEntity = WXContentEntity(){
        didSet{
            tempString = contentEntity.content
            imageModel = WXImageModel(JSONString: tempString!)
            tempRole = contentEntity.sender
        }
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        once.run {
            check()
        }
        initView()
    }
    func check() {
        if YLPermission.Photos.status == .notDetermined {
            YLPermission.Photos.request { [weak self] in
                self?.check()
            }
            
            return
        }
        
        if  YLPermission.Camera.status == .notDetermined {
            YLPermission.Camera.request { [weak self] in
                self?.check()
            }
            return
        }
        
        
    }
    func initView()  {
        
        
        self.view.backgroundColor = UIColor.rgbq(r: 238, g: 236, b: 243, a: 1)
        self.navigationItem.title = "图片设置"
        self.rightTitle = "保存"
        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
        
        self.automaticallyAdjustsScrollViewInsets = false
    }
    override func rightBtnClick(_ sender: UIButton) {
        guard let _ = self.imageModel else {
            self.view.showImageHUDText("请选择图片！")
            return
        } 
        
        let realm = try! Realm()
        
        try! realm.write {
            contentEntity.content = (self.imageModel?.toJSONString())!
            contentEntity.sender = tempRole
            if self.type == .Create || self.type == nil{
                let entities = realm.objects(WXContentEntity.self).filter("parent.id = %@",self.conversation?.id ?? "")
                contentEntity.index = entities.count+1
                contentEntity.parent = conversation
                contentEntity.id = UUID().uuidString
                contentEntity.contentType = 2
                realm.create(WXContentEntity.self, value: contentEntity, update: false)
                
            }
        }
        if block != nil {
            block!()
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    
}
extension ImageSetingViewController:UITableViewDelegate,UITableViewDataSource{
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
            cell.accessoryType = .disclosureIndicator
            cell.hintLabel.text = "选择图片"
            cell.nickNameLabel.isHidden = true
            if let _ = self.imageModel{
                cell.portraitIcon.kf.setImage(with:URL(fileURLWithPath: (self.imageModel?.path?.localPath())!))
            }else{
                cell.portraitIcon.image = UIImage(named: "default")
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
            let actionSheet = PGActionSheet(cancelButton: true, buttonList: ["拍照","相册选择"])
            actionSheet.actionSheetTranslucent = false
            present(actionSheet, animated: false, completion: {
            })
            actionSheet.handler = {
                [weak self] index  in
                self?.dismiss(animated: false, completion: nil)
                
                if index ==  0{
                    if YLPermission.Camera.status == .denied || YLPermission.Camera.status == .restricted{
                        let cancel = UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel, handler: nil)
                        let confirm = UIAlertAction(title: "确定", style: UIAlertActionStyle.default, handler:{ (actionSheet) in
                            DispatchQueue.main.async {
                                if let settingsURL = URL(string: UIApplicationOpenSettingsURLString) {
                                    UIApplication.shared.openURL(settingsURL)
                                }
                            }
                        })
                        let vc =   UIAlertController(title: "温馨提示", message: "拍照需要使用您的相机，您需要授权", preferredStyle: UIAlertControllerStyle.alert)
                        vc.addAction(cancel)
                        vc.addAction(confirm)
                        self?.present(vc, animated: true, completion: nil)
                        return
                    }
                    
                }else if index == 1{
                    if YLPermission.Photos.status == .denied || YLPermission.Photos.status == .restricted{
                        let cancel = UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel, handler: nil)
                        let confirm = UIAlertAction(title: "确定", style: UIAlertActionStyle.default, handler:{ (actionSheet) in
                            DispatchQueue.main.async {
                                if let settingsURL = URL(string: UIApplicationOpenSettingsURLString) {
                                    UIApplication.shared.openURL(settingsURL)
                                }
                            }
                        })
                        let vc =   UIAlertController(title: "温馨提示", message: "拍照需要使用您的相册，您需要授权", preferredStyle: UIAlertControllerStyle.alert)
                        vc.addAction(cancel)
                        vc.addAction(confirm)
                        self?.present(vc, animated: true, completion: nil)
                        return
                    }
                }
                var sourceType:UIImagePickerControllerSourceType?
                switch index{
                case 0:
                    sourceType = UIImagePickerControllerSourceType.camera
                    break
                case 1:
                    sourceType = UIImagePickerControllerSourceType.photoLibrary

                    break
                default:
                    break
                }
                
                let vc = UIImagePickerController()
                vc.allowsEditing = false
                vc.delegate = self
                vc.sourceType = sourceType!
                self?.present(vc, animated: true, completion: nil)
            }
            
        }
        
    }
}
extension ImageSetingViewController:UIImagePickerControllerDelegate ,UINavigationControllerDelegate{
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true) {
            
        }
        let image =  info[UIImagePickerControllerOriginalImage] as! UIImage
        let imagename = (UUID().uuidString+".png")
        let tempImage =  image.imageWithScale(width: 400)
        let data = tempImage.kf.jpegRepresentation(compressionQuality: 0.7)

        let path = imagename.localPath()
        try? data?.write(to: URL(fileURLWithPath: path))
         let model = WXImageModel()
        if image.size.width<400 {
            model.height = image.size.height
            model.width = image.size.width
        }else{
            model.height = 400 * image.size.height / image.size.width
            model.width = 400
         }
        model.path = imagename

        
        self.imageModel = model
        self.tableView.reloadData()
    }
}


