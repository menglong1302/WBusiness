//
//  AlipayConversationImageSettingViewController.swift
//  WCBusiness
//
//  Created by Ray on 2017/10/27.
//  Copyright © 2017年 LYL. All rights reserved.
//

import UIKit
import SnapKit
import RealmSwift
import PGActionSheet

class AlipayConversationImageSettingViewController : BaseViewController {
    lazy var tableView = self.initTableView()
//    var sender:Role?
//    var receiver:Role?
    var isEdit:Bool?
    var isSave:Bool? = false
    var index:Int?
    var acUser:AlipayConversationUser?
    var selectRole:Role?
    var originalContentSender:Role?
    var acContent:AlipayConversationContent?
    lazy var manager:HXPhotoManager = {
        () in
        let manager = HXPhotoManager(type: HXPhotoManagerSelectedTypePhoto)
        manager?.cameraType = HXPhotoManagerCameraTypeFullScreen
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
        self.navigationItem.title = "图片设置"
        self.view.backgroundColor = UIColor.init(hexString: "EFEFF4")
        self.initView()
        self.initRightNavBarBtn()
        if self.isEdit == true {
            self.selectRole = self.acContent?.contentSender
            self.originalContentSender = self.acContent?.contentSender
        } else {
            self.selectRole = self.acUser?.sender
        }
        initData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let realm = try! Realm()
        if self.isEdit == false && self.isSave == false {
            let acContent = realm.object(ofType: AlipayConversationContent.self, forPrimaryKey: self.acContent?.id)
            try! realm.write {
                realm.delete(acContent!)
            }
        } else if self.isEdit == true && self.isSave == false {
            try! realm.write {
                self.acContent?.contentSender = self.originalContentSender
            }
        }
    }
    func initView () {
        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints({(maker) in
            maker.edges.equalToSuperview()
        })
        
    }
    func initTableView() -> UITableView {
        let tableView = UITableView(frame:CGRect.zero)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.clear
        tableView.register(AlipayConversationSettingCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }
    func initRightNavBarBtn() {
        let rightBtn = UIButton.init(frame:CGRect.zero)
        rightBtn.setTitle("保存", for: .normal)
        rightBtn.addTarget(self,action:#selector(rightItemBtnAction), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: rightBtn)
    }
    func rightItemBtnAction() {
        self.isSave = true
        if self.acContent?.content == nil || self.acContent?.content == "" {
            self.view.showImageHUDText("没有选择图片")
        } else {
            let realm = try! Realm()
            try! realm.write {
                realm.create(AlipayConversationContent.self, value: self.acContent as Any, update: true)
            }
            self.navigationController?.popViewController(animated: true)
        }        
    }
    func initData() {
        if isEdit == false && self.acContent == nil{
            let realm = try! Realm()
            self.acContent = AlipayConversationContent()
            self.acContent?.id = UUID().uuidString
            self.acContent?.index = self.index!
            self.acContent?.type = "图片"
            self.acContent?.user = self.acUser
            self.acContent?.contentSender = self.acUser?.sender
            let date = NSDate()
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
            let strNowTime = timeFormatter.string(from: date as Date) as String
            self.acContent?.creatAt = strNowTime
            try! realm.write {
                realm.create(AlipayConversationContent.self, value: self.acContent as Any, update: false)
            }
        }
    }
}

extension AlipayConversationImageSettingViewController:UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect.init(x:0, y:0, width:self.view.frame.width, height:10.0));
        view.backgroundColor = UIColor.clear;
        return view;
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect.init(x:0, y:0, width:self.view.frame.width, height:10.0));
        view.backgroundColor = UIColor.clear;
        return view;
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! AlipayConversationSettingCell
        if indexPath.section == 0 {
            if (self.selectRole?.isDiskImage)! {
                cell.setData(["title":"选择发送人","name":(self.selectRole?.nickName)!,"imageName":""])
                if !(self.selectRole?.imageUrl.isEmpty)! {
                    cell.iconImage.kf.setImage(with: URL(fileURLWithPath: (self.selectRole?.imageUrl.localPath())!))
                }
            } else {
                if (selectRole?.imageName.isEmpty)! {
                    cell.setData(["title":"选择发送人","name":(self.selectRole?.nickName)!,"imageName":""])
                } else {
                    cell.setData(["title":"选择发送人","name":(self.selectRole?.nickName)!,"imageName":(self.selectRole?.imageName)!])
                }
            }
            
        } else {
            if self.acContent?.content != nil {
                cell.setData(["title":"选择照片","name":"","imageName":""])
                cell.iconImage.kf.setImage(with: URL(fileURLWithPath: (self.acContent?.content.localPath())!))
            } else {
                cell.setData(["title":"选择照片","name":"","imageName":""])
            }
            
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0 {
            if self.selectRole?.id == self.acUser?.sender?.id {
                self.selectRole = self.acUser?.receiver
            } else {
                self.selectRole = self.acUser?.sender
            }
            let realm = try! Realm()
            try! realm.write {
                self.acContent?.contentSender = self.selectRole
            }
            self.tableView.reloadData()
        } else {
            
                self.manager.clearSelectedList()
            let nav = UINavigationController(rootViewController: (self.photoVC));
                nav.isNavigationBarHidden = true
            self.isSave = true
            self.present(nav, animated: true, completion: nil)
        }
    }
}

extension AlipayConversationImageSettingViewController:HXPhotoViewControllerDelegate{
    func photoViewControllerDidCancel() {
    }
    func photoViewControllerDidNext(_ allList: [HXPhotoModel]!, photos: [HXPhotoModel]!, videos: [HXPhotoModel]!, original: Bool) {
        let model =  photos[0]
        let data = model.thumbPhoto.kf.jpegRepresentation(compressionQuality: 0.7)
        let imagename = (UUID().uuidString+".png")
        let path = imagename.localPath()
        try? data?.write(to: URL(fileURLWithPath: path))
        
        let realm = try! Realm()
        try! realm.write {
            self.acContent?.content = imagename
//            self.acUser.isDiskImage = true
        }
        self.dismiss(animated: false, completion: nil)
        self.tableView.reloadData()
        self.isSave = false
    }
}
