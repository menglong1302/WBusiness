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
class AlipayConversationViewController : BaseViewController  {
    var tableView:UITableView?
    var rigthBtn:UIButton?
    var footerView:UIView?
    var footerViewLeftBtn:UIButton?
    var footerViewRightBtn:UIButton?
    var alipayCAV:AlipayConversationAddView?
    var alipayCUser:AlipayConversationUser?
    let cellID = "cellID"
    var userId = ""
//    var window:UIWindow?
    var tableData = ["宝宝0","宝宝1","宝宝2","宝宝3","宝宝4","宝宝5","宝宝6"]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "支付宝对话"
        initRightItem()
        initView()
        initFooterView()
        initAddView()
        initData()
//        deleteData()
        self.view.backgroundColor = UIColor.init(hexString: "EFEFF4")
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
//        self.view.backgroundColor = UIColor.blue;
        //设置tableView的frame
        let tableViewHeight = self.view.frame.height-64-44-1;
//        print("View高度\(self.view.frame.height)");
        tableView = UITableView.init(frame:CGRect.init(x:0, y:0, width:self.view.frame.width, height:tableViewHeight),style:.grouped);
        //tableView的两个代理方法
        tableView?.delegate = self;
        tableView?.dataSource = self;
        tableView?.register(AlipayConversationSettingInfoCell.self, forCellReuseIdentifier: "settingInfoCell")
//        tableView.sectionHeaderHeight = 20;
        self.view.addSubview(tableView!)
        tableView?.reloadData()
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
        print("rightItemBtnAction")
        loadData()
    }
    func initAddView(){
        alipayCAV = AlipayConversationAddView.init(frame: CGRect.init(x:0,y:SCREEN_HEIGHT,width:SCREEN_WIDTH,height:SCREEN_HEIGHT))
//        window = (UIApplication.shared.delegate?.window)!
//        window?.addSubview(alipayCAV!)
    }
    func footerViewLeftBtnAction() -> Void {
        print("footerViewLeftBtnAction")
        self.view.addSubview(alipayCAV!);
        alipayCAV?.frame = CGRect.init(x:0,y:0,width:SCREEN_WIDTH,height:SCREEN_HEIGHT)
        UIView.animate(withDuration: 0.5, animations: {
            self.alipayCAV?.containerView?.frame = CGRect.init(x:0,y:0,width:SCREEN_WIDTH,height:SCREEN_HEIGHT-64)
            self.alipayCAV?.backgroundColor = UIColor(red: 0 / 255.0, green: 0 / 255.0, blue: 0 / 255.0, alpha: 0.5)
        })
    }
    func footerViewRightBtnAction(button:UIButton) -> Void {
        print("footerViewRightBtnAction=\(button)")
    }
    func writeData() -> Void {
        let realm = try! Realm()
        let sender = Role(value:["nickName":"Ray",
                                 "imageUrl":"",
                                 "isLocalImage":true,
                                 "isSelf":true,
                                 "imageName":"Image-1",
                                 "id":UUID().uuidString,
                                 "firstLetter":"R",])
        let receiver = Role(value:["nickName":"Yu",
                                   "imageUrl":"",
                                   "isLocalImage":true,
                                   "isSelf":false,
                                   "imageName":"Image-2",
                                   "id":UUID().uuidString,
                                   "firstLetter":"Y",])
        let date = NSDate()
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        let strNowTime = timeFormatter.string(from: date as Date) as String

        let alipayConversationUser = AlipayConversationUser()
        alipayConversationUser.id = UUID().uuidString
        alipayConversationUser.sender = sender
        alipayConversationUser.receiver = receiver
        alipayConversationUser.backgroundImageUrl = ""
        alipayConversationUser.isLocalImage = true
        alipayConversationUser.backgroundImageName = ""
        alipayConversationUser.isFriend = true
        alipayConversationUser.creatAt = strNowTime
        
        let alipayConversationContent = AlipayConversationContent()
        alipayConversationContent.id = UUID().uuidString
        alipayConversationContent.user = alipayConversationUser
        alipayConversationContent.type = ""
        alipayConversationContent.index = ""
        alipayConversationContent.content = ""
        alipayConversationContent.creatAt = strNowTime
        
        try! realm.write {
            realm.add(alipayConversationContent)
        }
    }
    func loadData() -> Void {
        let realm = try! Realm()
        let alipayConversationUser = realm.objects(AlipayConversationUser.self)
        print(alipayConversationUser)
    }
    func deleteData () {
        let realm = try! Realm()
//        let role1 = realm.object(ofType: Role.self, forPrimaryKey: "2FED7A54-291D-4AE2-B5EB-A871D20BCD12")
//        let role2 = realm.object(ofType: Role.self, forPrimaryKey: "3A189ED6-E5C4-477E-BDD4-31CDE24006EA")
        let alipayConversationUser = realm.object(ofType: AlipayConversationUser.self, forPrimaryKey: "56E68463-02BB-4A0C-A545-602E3F56E3C2")
        /* 在事务中删除数据 */
        try! realm.write {
//            realm.delete(role1!) // 删除数据
//            realm.delete(role2!)
            realm.delete(alipayConversationUser!)
        }
    }
    func initData () {
        let realm = try! Realm()
//        let alipayConversationContent = realm.objects(AlipayConversationContent.self)
//        if (alipayConversationContent.count == 0){
        let alipayConversationUser = realm.objects(AlipayConversationUser.self)
        if (alipayConversationUser.count == 0){
            print ("数据库无数据")
            let sender = Role(value:["nickName":"Ray",
                                     "imageUrl":"",
                                     "isLocalImage":true,
                                     "isSelf":true,
                                     "imageName":"Image-1",
                                     "id":UUID().uuidString,
                                     "firstLetter":"R",])
            let receiver = Role(value:["nickName":"Yu",
                                       "imageUrl":"",
                                       "isLocalImage":true,
                                       "isSelf":false,
                                       "imageName":"Image-2",
                                       "id":UUID().uuidString,
                                       "firstLetter":"Y",])
            let date = NSDate()
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
            let strNowTime = timeFormatter.string(from: date as Date) as String
            
            let alipayConversationUser = AlipayConversationUser()
            alipayConversationUser.id = UUID().uuidString
            alipayConversationUser.sender = sender
            alipayConversationUser.receiver = receiver
            alipayConversationUser.backgroundImageUrl = ""
            alipayConversationUser.isLocalImage = true
            alipayConversationUser.backgroundImageName = ""
            alipayConversationUser.isFriend = true
            alipayConversationUser.creatAt = strNowTime
            try! realm.write {
                realm.add(alipayConversationUser)
            }
        } else {
            print ("数据库有数据")
            alipayCUser = AlipayConversationUser()
            alipayCUser = alipayConversationUser[0]
            print(alipayCUser as Any)
            userId = alipayConversationUser[0].id
        }
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
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (indexPath.section == 0 && indexPath.row == 0) {
            let settingInfoCell = tableView.dequeueReusableCell(withIdentifier: "settingInfoCell",for: indexPath) as! AlipayConversationSettingInfoCell
            settingInfoCell.setData(["name":"设置资料","imageName1":(alipayCUser?.sender?.imageName)!,"imageName2":(alipayCUser?.receiver?.imageName)!])

            return settingInfoCell
        } else {
            let identifier="identtifier";
            var cell=tableView.dequeueReusableCell(withIdentifier: identifier)
            if(cell == nil){
                cell=UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: identifier);
            }
            cell?.textLabel?.text = tableData[indexPath.row];
            cell?.detailTextLabel?.text = "待添加内容";
            cell?.detailTextLabel?.font = UIFont .systemFont(ofSize: CGFloat(13))
            cell?.accessoryType=UITableViewCellAccessoryType.disclosureIndicator
            return cell!
        }
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row);
        if indexPath.section == 0 {
           if indexPath.row == 0 {
                let alipayCSVC = AlipayConversationSettingViewController()
                alipayCSVC.userId = userId
                self.navigationController?.pushViewController(alipayCSVC, animated: true)
            }
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
}
