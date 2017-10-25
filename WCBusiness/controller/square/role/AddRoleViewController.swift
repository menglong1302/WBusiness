//
//  AddRoleViewController.swift
//  WCBusiness
//
//  Created by YangXL on 2017/10/25.
//  Copyright © 2017年 LYL. All rights reserved.
//
import UIKit
import SnapKit
import Kingfisher
import PGActionSheet
import RealmSwift
typealias AddBlock = () -> Void
class AddRoleViewController: BaseViewController {
    var block:AddBlock?
    var tempImageUrl:String?
    var tempNickName:String?
    var footerView:UIView = {
        let view = UIView()
        return view
    }()
    var saveBtn:UIButton = {
        
        let btn = UIButton(type:UIButtonType.custom)
        btn.setTitle("保存", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.addTarget(self, action: #selector(saveBtnClick(_:)), for: .touchUpInside)
        btn.layer.cornerRadius = 5
        btn.layer.masksToBounds = true
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.backgroundColor = UIColor.flatCoffee
        return  btn
    }()
    
    
    
    lazy var tableView = { () -> UITableView in
        let tableView = UITableView(frame: CGRect.zero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(RoleEditTableViewCell.self, forCellReuseIdentifier: "editCellId")
        
        return tableView
    }()
    
    lazy var manager:HXPhotoManager = {
        () in
        let manager = HXPhotoManager(type: HXPhotoManagerSelectedTypePhotoAndVideo)
        manager?.outerCamera = true
        manager?.openCamera = true
        manager?.saveSystemAblum = true
        manager?.singleSelected = true
        manager?.singleSelecteClip = false
        
        return manager!
    }()
    lazy var photoVC = {
        () -> HXPhotoViewController in
        let vc = HXPhotoViewController()
        vc.manager = self.manager;
        vc.delegate = self;
        return vc
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "新建角色"
        initView()
        
    }
    
    func initView()  {
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(tableView)
        footerView.addSubview(saveBtn)
        self.view.addSubview(footerView)
        tableView.tableFooterView = UIView()
        tableView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
        
        footerView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(0)
            maker.bottom.equalTo(0).offset(-10)
            maker.height.equalTo(44)
        }
        saveBtn.snp.makeConstraints { (maker) in
            
            maker.edges.equalTo(footerView).inset(UIEdgeInsetsMake(2, 15, 2, 15))
            
        }
    }
    
    func  saveBtnClick(_ btn:UIButton) {
        if tempImageUrl == nil{
            self.view.showImageHUDText("图片不能为空")
            return
        }
        if tempNickName == nil {
            self.view.showImageHUDText("昵称不能为空")
            return
        }
        saveData()
        if block != nil {
            block!()
        }
        dismiss(animated: true, completion: nil)
    }
    func saveData() {
        let realm = try! Realm()
        let role = Role()
        role.id = UUID().uuidString
        role.nickName = tempNickName!
        role.imageName = ""
        role.isDiskImage = true
        role.isSelf = true
        role.imageUrl = tempImageUrl!
        role.firstLetter =  ""
        
        try! realm.write {
            realm.create(Role.self, value: role, update: false)
        }
    }
    override func touchLeftBtn() {
        self.dismiss(animated: true, completion: nil)
    }
}

extension AddRoleViewController:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "editCellId") as! RoleEditTableViewCell
        cell.accessoryType = .disclosureIndicator
        if indexPath.row == 0 {
            cell.hintLabel.text = "头像"
            cell.nickNameLabel.isHidden = true
            cell.portraitIcon.isHidden = false
            if let temp = tempImageUrl,!(temp.isEmpty){
                cell.portraitIcon.kf.setImage(with: URL(fileURLWithPath: temp.localPath()))
            }else{
                cell.portraitIcon.image = UIImage(named:"portrait")
            }
        }else{
            cell.hintLabel.text = "昵称"
            cell.portraitIcon.isHidden = true
            cell.nickNameLabel.isHidden = false
            if let name = self.tempNickName{
                cell.nickNameLabel.text = name
            }else{
                cell.nickNameLabel.text = ""
                
            }
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50;
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 1 {
            let nameEditVC  = NameEditViewController()
            if let tempName = self.tempNickName {
                nameEditVC.tempName = tempName
            }else{
                nameEditVC.tempName = ""
                
            }
            nameEditVC.nameBlock = {
                (name:String)->Void in
                self.tempNickName = name
                
                self.tableView.reloadData()
                
            }
            self.navigationController?.pushViewController(nameEditVC, animated: true)
        }else{
            self.manager.clearSelectedList()
            
            let nav = UINavigationController(rootViewController: self.photoVC);
            nav.isNavigationBarHidden = true
            self.present(nav, animated: true, completion: nil)
            
        }
        
    }
}
extension AddRoleViewController:HXPhotoViewControllerDelegate{
    func photoViewControllerDidCancel() {
    }
    func photoViewControllerDidNext(_ allList: [HXPhotoModel]!, photos: [HXPhotoModel]!, videos: [HXPhotoModel]!, original: Bool) {
        let model =  photos[0]
        
        let clipVC = TOCropViewController(croppingStyle: .default, image: model.thumbPhoto)
        clipVC.customAspectRatio = CGSize(width: 1, height: 1)
        clipVC.aspectRatioPickerButtonHidden = true
        clipVC.rotateClockwiseButtonHidden = true
        clipVC.rotateButtonsHidden = true
        clipVC.resetAspectRatioEnabled = false
        clipVC.aspectRatioLockEnabled = true
        clipVC.delegate = self
        self.navigationController?.pushViewController(clipVC, animated: false)
    }
}
extension AddRoleViewController:TOCropViewControllerDelegate{
    func cropViewController(_ cropViewController: TOCropViewController, didFinishCancelled cancelled: Bool) {
        self.navigationController?.popViewController(animated: false)
    }
    func cropViewController(_ cropViewController: TOCropViewController, didCropToImage image: UIImage, rect cropRect: CGRect, angle: Int) {
        let data = image.kf.jpegRepresentation(compressionQuality: 0.7)
        let imagename = (UUID().uuidString+".png")
        let path = imagename.localPath()
        try? data?.write(to: URL(fileURLWithPath: path))
        tempImageUrl = imagename
        
        self.tableView.reloadData()
        self.navigationController?.popViewController(animated: false)
        
    }
    
}







