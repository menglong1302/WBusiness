//
//  WXChatViewController.swift
//  WCBusiness
//
//  Created by YangXL on 2017/11/14.
//  Copyright © 2017年 LYL. All rights reserved.
//

import Foundation
import ChameleonFramework
import RealmSwift
class WXChatViewController: UIViewController {
    
    
    var conversationType:ConversationType?
    var contents:List<WXContentEntity>?
    var conversation:WXConversation?
    lazy var tableView:UITableView = self.makeTableView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
        
    }
    func initView()  {
        
        self.navigationItem.title = "微信"
        
        self.automaticallyAdjustsScrollViewInsets = false
        self.edgesForExtendedLayout = UIRectEdge.all
        let container = UIControl()
        container.backgroundColor = UIColor.clear
        container.addTarget(self, action: #selector(leftBtnClick), for: .touchUpInside)
        let imageView:UIImageView = {
            let view = UIImageView()
            view.image = UIImage(named:"wxback")
            view.contentMode = .scaleAspectFill
            return view
        }()
        let label:UILabel = {
            let label = UILabel()
            label.text = "微信"
            label.font = UIFont.systemFont(ofSize: 15.8)
            label.textColor = UIColor.white
            return label
        }()
        [imageView,label].forEach {
            container.addSubview($0)
        }
        let leftItem =  UIBarButtonItem(customView: container)
        container.snp.makeConstraints { (maker) in
            maker.width.equalTo(40)
            maker.height.equalTo(35)
        }
        imageView.snp.makeConstraints { (maker) in
            maker.left.equalToSuperview().offset(-5)
            maker.width.equalTo(15)
            maker.height.equalTo(30)
            maker.centerY.equalToSuperview()
        }
        label.snp.makeConstraints { (maker) in
            maker.centerY.equalToSuperview().offset(0.8)
            maker.left.equalTo(imageView.snp.right).offset(-0.3)
        }
        self.navigationItem.leftBarButtonItem = leftItem
        
        let titleView:UILabel = {
            let label = UILabel()
            label.text = "IT部门(11)"
            label.textColor = UIColor.white
            label.font = UIFont.boldSystemFont(ofSize: 18)
            return label
        }()
        self.navigationItem.titleView = titleView
        
        
        let rightBtn:UIButton = {
            let btn = UIButton(type: .custom)
            btn.setImage(UIImage(named: "barbuttonicon_InfoMulti"), for: .normal)
            return btn
        }()
        rightBtn.imageView?.snp.makeConstraints({ (maker) in
            maker.right.equalToSuperview().offset(5)
            maker.width.height.equalTo(30)
        })
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightBtn)
        
        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
        
    }
    
    func makeTableView() -> UITableView {
        let view = UITableView()
        view.delegate = self
        view.dataSource = self
        view.separatorStyle = .none
        view.estimatedRowHeight = 50
        view.backgroundColor = HexColor("EBEBEB")
        view.contentInset = UIEdgeInsetsMake(0, 0, 49, 0)
        view.rowHeight =  UITableViewAutomaticDimension
        view.register(WXMessageTextCell.self, forCellReuseIdentifier: "textCellId")
        view.register(WXMessageImageCell.self, forCellReuseIdentifier: "imageCellId")
        view.register(WXMessageVoiceCell.self, forCellReuseIdentifier: "voiceCellId")
        view.register(WXMessageSystemCell.self, forCellReuseIdentifier: "systemCellId")
        
        
        
        return view
    }
    
    @objc func leftBtnClick(){
        self.dismiss(animated: true, completion: nil)
    }
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
}
extension WXChatViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.contents?.count)!
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let entity = self.contents![indexPath.row]
        let cell:WXMessageBaseCell?
        switch entity.contentType {
        case 1:
            cell = tableView.dequeueReusableCell(withIdentifier: "textCellId") as? WXMessageBaseCell
        case 2:
            cell = tableView.dequeueReusableCell(withIdentifier: "imageCellId") as? WXMessageBaseCell
        case 3:
            cell = tableView.dequeueReusableCell(withIdentifier: "voiceCellId") as? WXMessageBaseCell
        case 6:
            let tempCell = tableView.dequeueReusableCell(withIdentifier: "systemCellId") as? WXMessageSystemCell
            tempCell?.entity = self.contents![indexPath.row]
            tempCell?.conversation = self.conversation
            tempCell?.setView()
            return tempCell!
        case 7:
            let tempCell = tableView.dequeueReusableCell(withIdentifier: "systemCellId") as? WXMessageSystemCell
            tempCell?.entity = self.contents![indexPath.row]
            tempCell?.conversation = self.conversation
            tempCell?.setView()
            return tempCell!
        default:
            cell = tableView.dequeueReusableCell(withIdentifier: "textCellId") as? WXMessageBaseCell
            break
        }
        cell?.backgroundColor = UIColor.clear
        cell?.entity = self.contents![indexPath.row]
        cell?.conversation = self.conversation
        cell?.updateMessage()
        return cell!
    }
}
