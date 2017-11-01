//
//  AlipayConversationViewController.swift
//  WCBusiness
//
//  Created by Ray on 2017/10/13.
//  Copyright © 2017年 LYL. All rights reserved.
//

import UIKit
import SnapKit
import RealmSwift
import Kingfisher

class AlipayConversationViewController : BaseViewController  {
    var tableView:UITableView?
    var rigthBtn:UIButton?
    var footerView:UIView?
    var footerViewLeftBtn:UIButton?
    var footerViewRightBtn:UIButton?
    var alipayCAV:AlipayConversationAddView?
    //    var tableData:[AlipayConversationContent] = []
    var tableData:Array<AlipayConversationContent> = []
    lazy var acUser = AlipayConversationUser()
    var index:String?
//    var isEdite = false
    var indexPath:IndexPath?
    var targetIndexPath:IndexPath?
    lazy var dragingCell = self.initDragingCell()
    var tempView:UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "支付宝对话"
        initRightItem()
        initView()
        initFooterView()
        initAddView()
        self.view.backgroundColor = UIColor.init(hexString: "EFEFF4")
        self.index = String(self.tableData.count)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initData ()
    }
    func initDragingCell() -> AlipayConversationContentCell {
        let cell = AlipayConversationContentCell(frame:CGRect(x:0,y:0,width:SCREEN_WIDTH,height:50))
        cell.isHidden = true
        return cell
    }
    func initRightItem() -> Void {
        rigthBtn = UIButton.init(frame:CGRect.zero);
        rigthBtn?.setImage(UIImage.init(named: "portrait"), for: .normal);
        rigthBtn?.addTarget(self,action:#selector(rightItemBtnAction), for: .touchUpInside)
        rigthBtn?.snp.makeConstraints({(maker) in
            maker.width.equalTo(30)
            maker.height.equalTo(30)
        })
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: rigthBtn!);
    }
    func initView() -> Void {
        let tableViewHeight = self.view.frame.height-64-44-1;
        tableView = UITableView.init(frame:CGRect.init(x:0, y:0, width:self.view.frame.width, height:tableViewHeight),style:.grouped);
        tableView?.delegate = self;
        tableView?.dataSource = self;
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressGesture(_:)))
        tableView?.addGestureRecognizer(longPress)
        tableView?.register(AlipayConversationSettingInfoCell.self, forCellReuseIdentifier: "settingInfoCell")
        tableView?.register(AlipayConversationContentCell.self, forCellReuseIdentifier: "cell")
        self.view.addSubview(tableView!)
    }
    
    func initFooterView() -> Void {
        footerView = UIView.init(frame:CGRect.zero);
        self.view.addSubview(footerView!);
        footerView?.backgroundColor = UIColor.clear;

        footerViewLeftBtn = UIButton.init(frame: CGRect.zero);
        footerView?.addSubview(footerViewLeftBtn!);
        footerViewLeftBtn?.backgroundColor = UIColor.white;
        footerViewLeftBtn?.setTitleColor(UIColor.black, for: .normal);
        footerViewLeftBtn?.setTitle("添加对话", for: .normal);
        footerViewLeftBtn?.contentHorizontalAlignment = .center;
        footerViewLeftBtn?.titleLabel?.font = UIFont.systemFont(ofSize: 15.0);
        footerViewLeftBtn?.addTarget(self,action:#selector(footerViewLeftBtnAction), for: .touchUpInside)
        
        footerViewRightBtn = UIButton.init(frame: CGRect.zero);
        footerView?.addSubview(footerViewRightBtn!);
        footerViewRightBtn?.backgroundColor = UIColor.blue;
        footerViewRightBtn?.setTitleColor(UIColor.white, for: .normal);
        footerViewRightBtn?.setTitle("生成预览", for: .normal);
        footerViewRightBtn?.contentHorizontalAlignment = .center;
        footerViewRightBtn?.titleLabel?.font = UIFont.systemFont(ofSize: 15.0);
        footerViewRightBtn?.addTarget(self, action:#selector(footerViewRightBtnAction(button:)), for:.touchUpInside)
        
        footerView?.snp.makeConstraints({ (maker) in
            maker.left.right.bottom.equalToSuperview()
            maker.height.equalTo(44)
        })
        footerViewLeftBtn?.snp.makeConstraints({(maker) in
            maker.left.bottom.equalToSuperview()
            maker.height.equalTo(44)
            maker.width.equalTo(self.view.frame.width/2)
        })
        footerViewRightBtn?.snp.makeConstraints({(maker) in
            maker.right.bottom.equalToSuperview()
            maker.height.equalTo(44)
            maker.width.equalTo(self.view.frame.width/2)
        })
    }
    func rightItemBtnAction() -> Void {
        //        print("rightItemBtnAction")
        //        loadData()
    }
    func initAddView(){
        alipayCAV = AlipayConversationAddView.init(frame: CGRect.init(x:0,y:SCREEN_HEIGHT,width:SCREEN_WIDTH,height:SCREEN_HEIGHT))
    }
    func footerViewLeftBtnAction() -> Void {
        self.view.addSubview(alipayCAV!);
        alipayCAV?.frame = CGRect.init(x:0,y:0,width:SCREEN_WIDTH,height:SCREEN_HEIGHT)
        UIView.animate(withDuration: 0.5, animations: {
            self.alipayCAV?.containerView?.frame = CGRect.init(x:0,y:0,width:SCREEN_WIDTH,height:SCREEN_HEIGHT-64)
            self.alipayCAV?.backgroundColor = UIColor(red: 0 / 255.0, green: 0 / 255.0, blue: 0 / 255.0, alpha: 0.5)
        })
        alipayCAV?.indexRowBlock = {
            [weak self] (row:Int) in
            switch row {
            case 0:
                break
            case 1:
                let alipayConversationISVC = AlipayConversationImageSettingViewController()
                if self?.acUser.sender != nil && self?.acUser.receiver != nil {
                    alipayConversationISVC.acUser = self?.acUser
                    alipayConversationISVC.index = self?.index
                    alipayConversationISVC.isEdit = false
                    self?.navigationController?.pushViewController(alipayConversationISVC, animated: true)
                } else {
                    self?.view.showImageHUDText("请先设置角色")
                }
                break
            case 2:
                break
            default:
                break
            }
        }
    }
    func footerViewRightBtnAction(button:UIButton) -> Void {
        //        print("footerViewRightBtnAction=\(button)")
    }
    
    func initData () {
        let realm = try! Realm()
        if let alipayConversationUser = realm.objects(AlipayConversationUser.self).first{
            self.acUser = alipayConversationUser
            self.tableData = []
            let alipayConversationContent = realm.objects(AlipayConversationContent.self).sorted(byKeyPath: "index");
            for var item in alipayConversationContent {
                self.tableData.append(item)
            }
        }else{
            self.acUser = AlipayConversationUser()
            self.acUser.id = UUID().uuidString
            let date = NSDate()
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
            let strNowTime = timeFormatter.string(from: date as Date) as String
            self.acUser.creatAt = strNowTime
            try! realm.write {
                realm.create(AlipayConversationUser.self, value: acUser, update: false)
            }
        }
        self.tableView?.reloadData()
    }
    func deleteBtnAction(button:UIButton) -> Void {
        var indexPath = self.tableView?.indexPath(for: button.superview as! AlipayConversationContentCell)
        let realm = try! Realm()
        try! realm.write {
            realm.delete(self.tableData[(indexPath?.row)!])
        }
        self.tableData.remove(at: (indexPath?.row)!)
        self.tableView?.reloadData()
    }
    func SnapshotViewWithInputView (inputView:UIView) -> UIImageView {
        UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, false, 0)
        inputView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();
        let snapshot = UIImageView.init(image: image)
        return snapshot
    }
    //MARK: - 长按动作
    func longPressGesture(_ tap: UILongPressGestureRecognizer) {
//        if !isEdite {
//            isEdite = !isEdite
//            self.tableView?.reloadData()
//            return
//        }
        let point = tap.location(in: self.tableView)
        switch tap.state {
        case UIGestureRecognizerState.began:
            dragBegan(point: point)
        case UIGestureRecognizerState.changed:
            drageChanged(point: point)
        case UIGestureRecognizerState.ended:
            drageEnded(point: point)
        case UIGestureRecognizerState.cancelled:
            drageEnded(point: point)
        default: break
        }
    }
    //MARK: - 长按开始
    func dragBegan(point: CGPoint) {
        indexPath = self.tableView?.indexPathForRow(at: point)
        if indexPath == nil || (indexPath?.section)! < 1 {
            return
        }
        let cell = self.tableView?.cellForRow(at: indexPath!) as? AlipayConversationContentCell
//        cell?.isHidden = true
        dragingCell.isHidden = false
        dragingCell.frame = (cell?.frame)!
        dragingCell.iconImage?.image = cell?.iconImage?.image
        dragingCell.typeLabel?.text = cell?.typeLabel?.text
        dragingCell.contentLabel?.text = cell?.contentLabel?.text
        dragingCell.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        self.tempView = SnapshotViewWithInputView(inputView: cell!)
        self.tempView?.frame = (cell?.frame)!
        self.view.addSubview(self.tempView!)
        cell?.isHidden = true
        UIView.animate(withDuration: 0.25) {
            self.tempView?.center = CGPoint.init(x: (self.tempView?.center.x)!, y: point.y)
        }
    }
    //MARK: - 长按过程
    func drageChanged(point: CGPoint) {
        if indexPath == nil || (indexPath?.section)! < 1 {
            return
        }
        dragingCell.center = point
        targetIndexPath = self.tableView?.indexPathForRow(at: point)
        if targetIndexPath == nil || (targetIndexPath?.section)! < 1 || indexPath == targetIndexPath{
            return
        }
        // 更新数据
        let item = self.tableData.remove(at: indexPath!.row)
        self.tableData.insert(item, at: targetIndexPath!.row)
        
        //交换位置
        self.tableView?.moveRow(at: indexPath!, to: targetIndexPath!)
        indexPath = targetIndexPath
        //让截图跟随手势
        self.tempView?.center = CGPoint.init(x: (self.tempView?.center.x)!, y: point.y)
    }
    //MARK: - 长按结束
    func drageEnded(point: CGPoint) {
        if indexPath == nil || (indexPath?.section)! < 1 {
            return
        }
        let endCell = self.tableView?.cellForRow(at: indexPath!)
        UIView.animate(withDuration: 0.25, animations: {
            self.dragingCell.transform = CGAffineTransform.identity
            self.dragingCell.center = (endCell?.center)!
            self.tempView?.frame = (endCell?.frame)!
        }, completion: {
            (finish) -> () in
            endCell?.isHidden = false
            self.dragingCell.isHidden = true
            self.indexPath = nil
            self.tempView?.removeFromSuperview()
            self.tempView = nil
//            var index:Int
            let realm = try! Realm()
            for index in 0 ..< self.tableData.count {
                try! realm.write {
                    self.tableData[index].index = String(index)
                }
            }
            self.tableView?.reloadData()
        })
    }
}
//talbeView 的两个代理方法的实现，其实这两个代理还能加到class声明的后面，代理方法的时候和OC里面的实现是一样的
extension AlipayConversationViewController:UITableViewDataSource,UITableViewDelegate {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2;
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0) {
            return 1;
        } else {
            return tableData.count;
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50;
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10;
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1;
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
        if (indexPath.section == 0 && indexPath.row == 0) {
            let settingInfoCell = tableView.dequeueReusableCell(withIdentifier: "settingInfoCell",for: indexPath) as! AlipayConversationSettingInfoCell
            if (acUser.sender != nil && acUser.receiver != nil){
                if (acUser.sender?.isDiskImage)!{
                    let imageUrl1 = acUser.sender?.imageUrl
                    if !((imageUrl1?.isEmpty)!) {
                        settingInfoCell.iconImage1.kf.setImage(with: URL(fileURLWithPath: (imageUrl1?.localPath())!))
                    }
                } else {
                    settingInfoCell.setData(["imageName1":(acUser.sender?.imageName ?? "portrait")])
                }
                if (acUser.receiver?.isDiskImage)!{
                    let imageUrl2 = acUser.receiver?.imageUrl
                    if !((imageUrl2?.isEmpty)!) {
                        settingInfoCell.iconImage2.kf.setImage(with: URL(fileURLWithPath: (imageUrl2?.localPath())!))
                    }
                } else {
                    settingInfoCell.setData(["imageName2":(acUser.receiver?.imageName ?? "portrait")])
                }
            } else {
                settingInfoCell.setData(["imageName1":"portrait","imageName2":"portrait"])
            }
            return settingInfoCell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! AlipayConversationContentCell
            cell.setData(["data" : self.tableData[indexPath.row]])
            cell.deleteBtn?.addTarget(self, action:#selector(deleteBtnAction(button:)), for: .touchUpInside)
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                let alipayCSVC = AlipayConversationSettingViewController()
                alipayCSVC.acUser = acUser
                self.navigationController?.pushViewController(alipayCSVC, animated: true)
            }
        } else {
            let acisvc = AlipayConversationImageSettingViewController()
            acisvc.index = String(indexPath.row)
            acisvc.acUser = self.acUser
            acisvc.isEdit = true
            acisvc.acContent = self.tableData[indexPath.row]
            self.navigationController?.pushViewController(acisvc, animated: true)
        }
    }
}
