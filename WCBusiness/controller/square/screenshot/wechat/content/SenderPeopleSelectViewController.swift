
//
//  SenderPeopleSelectViewController.swift
//  WCBusiness
//
//  Created by YangXL on 2017/10/30.
//  Copyright © 2017年 LYL. All rights reserved.
//

import Foundation
typealias SelectPeople = (Role) ->Void

class SenderPeopleSelectViewController: BaseViewController {
    lazy var tableView:UITableView = {
        let tableView = UITableView(frame: CGRect.zero)
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = UIColor.rgbq(r: 238, g: 236, b: 243, a: 1)
        tableView.separatorInset = UIEdgeInsetsMake(0, 10, 0, 0 )
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 50
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.register(SelectPeopleTableViewCell.self, forCellReuseIdentifier: "SelectPeopleCellId")
        return tableView
    }()
    var conversation:WXConversation?{
        didSet{
            array.append((conversation?.sender)!)
            for role in (conversation?.receivers)!{
                array.append(role)
            }
            self.tableView.reloadData()
        }
    }
    lazy var array = [Role]()
    var block:SelectPeople?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "选择发送人"
        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
    }
    
}
extension SenderPeopleSelectViewController:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SelectPeopleCellId") as! SelectPeopleTableViewCell
        let role = array[indexPath.row]
        if role.isDiskImage {
            cell.portraitIcon.kf.setImage(with: URL(fileURLWithPath: role.imageUrl.localPath() ) )
        }else{
            cell.portraitIcon.image = UIImage(named:role.imageName)
        }
        cell.nameLabel.text = role.nickName
        return cell
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if block != nil{
            let role = array[indexPath.row]
            block!(role)
            self.navigationController?.popViewController(animated: true)
        }
    }
}
