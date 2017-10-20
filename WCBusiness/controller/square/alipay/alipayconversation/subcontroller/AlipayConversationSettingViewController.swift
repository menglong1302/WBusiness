//
//  AlipayConversationSettingViewController.swift
//  WCBusiness
//
//  Created by Ray on 2017/10/19.
//  Copyright © 2017年 LYL. All rights reserved.
//

import UIKit
import SnapKit
import PGActionSheet

class AlipayConversationSettingViewController : BaseViewController  {
    var tableView:UITableView?
    var rigthBtn:UIButton?
    var footerView:UIView?
    var footerViewLeftBtn:UIButton?
    var footerViewRightBtn:UIButton?
    var alipayCSCRV:AlipayConversationSettingCellRoleView?
    let cellID = "cellID"
    //    var window:UIWindow?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "单聊设置"
        initView()
        initAlipayCSCRView()
        self.view.backgroundColor = UIColor.init(hexString: "EFEFF4")
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
        tableView?.register(AlipayConversationSettingCell.self, forCellReuseIdentifier: "cell");
        tableView?.register(AlipayConversationSettingSwitchCell.self, forCellReuseIdentifier: "switchCell");
        //        tableView.sectionHeaderHeight = 20;
        self.view.addSubview(tableView!)
        tableView?.reloadData()
    }
    func initAlipayCSCRView(){
        alipayCSCRV = AlipayConversationSettingCellRoleView.init(frame: CGRect.init(x:0,y:SCREEN_HEIGHT,width:SCREEN_WIDTH,height:SCREEN_HEIGHT))
    }
}
//talbeView 的两个代理方法的实现，其实这两个代理还能加到class声明的后面，代理方法的时候和OC里面的实现是一样的
extension AlipayConversationSettingViewController:UITableViewDataSource,UITableViewDelegate {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2;
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2;
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.section == 1 && indexPath.row == 1) {
            let switchCell = tableView.dequeueReusableCell(withIdentifier: "switchCell") as! AlipayConversationSettingSwitchCell
            switchCell.setData(["title":"已添加对方为好友"])
            switchCell.selectionStyle = .none
            return switchCell
        } else {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! AlipayConversationSettingCell
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                cell.setData(["title":"用户1","name":"Ray"])
            } else {
                cell.setData(["title":"用户2","name":"Test"])
            }
        } else {
            if indexPath.row == 0 {
                cell.setData(["title":"修改聊天背景","name":""])
            }
          }
          return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            self.view.addSubview(alipayCSCRV!);
            alipayCSCRV?.frame = CGRect.init(x:0,y:0,width:SCREEN_WIDTH,height:SCREEN_HEIGHT)
            UIView.animate(withDuration: 0.5, animations: {
                self.alipayCSCRV?.containerView?.frame = CGRect.init(x:0,y:0,width:SCREEN_WIDTH,height:SCREEN_HEIGHT-64)
                self.alipayCSCRV?.backgroundColor = UIColor(red: 0 / 255.0, green: 0 / 255.0, blue: 0 / 255.0, alpha: 0.5)
            })
        } else {
            if indexPath.section == 1 && indexPath.row == 0 {
                let actionSheet = PGActionSheet(cancelButton: true, buttonList: ["默认","相册","照相机"])
                actionSheet.actionSheetTranslucent = false
                actionSheet.handler = {index in
                    print("index = ", index)
                }
                present(actionSheet, animated: false, completion: nil)
            } else if (indexPath.section == 1 && indexPath.row == 1) {
                 print(indexPath.row);
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

