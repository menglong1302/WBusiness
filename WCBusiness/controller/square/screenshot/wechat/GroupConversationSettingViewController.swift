//
//  GroupConversationSettingViewController.swift
//  WCBusiness
//
//  Created by YangXL on 2017/10/25.
//  Copyright © 2017年 LYL. All rights reserved.
//

import Foundation
class GroupConversationSettingViewController: BaseViewController {
    
    lazy var tableView = self.makeTableView()
    var conversation:WXConversation?{
        didSet{
            for role in (conversation?.receivers)!{
                peopleArray.append(PeopleModel(role: role))
            }
            let model =  PeopleModel()
            model.isAdd = true
            peopleArray.append(model)
        }
    }
    var peopleArray = [PeopleModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    func initView()  {
        view.backgroundColor = UIColor.rgbq(r: 238, g: 236, b: 243, a: 1)
        navigationItem.title = "群聊设置"
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (maker) in
            maker.left.right.top.bottom.equalToSuperview()
        }
    }
    
    
    func makeTableView() -> UITableView {
        let tableView = UITableView(frame: CGRect.zero)
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = UIColor.rgbq(r: 238, g: 236, b: 243, a: 1)
        tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0 )
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ChangeRoleTableViewCell.self, forCellReuseIdentifier: "roleCellId")
        tableView.register(ChatSettingTableViewCell.self, forCellReuseIdentifier: "chatSettingCellId")
        tableView.register(GroupSelectPeopleTableViewCell.self, forCellReuseIdentifier: "groupSelectCellId")
        tableView.estimatedRowHeight = 50
        tableView.rowHeight = UITableViewAutomaticDimension
        return tableView
    }
}

extension GroupConversationSettingViewController:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            let tempCell =   tableView.dequeueReusableCell(withIdentifier: "groupSelectCellId") as! GroupSelectPeopleTableViewCell
            tempCell.collectionView.delegate = self
            tempCell.collectionView.dataSource = self
            tempCell.configer(conversation!)
            
            return tempCell
        }
        
        
        return UITableViewCell()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
}

extension GroupConversationSettingViewController:UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.peopleArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GroupPersionCellId", for: indexPath) as! GroupPersionCollectionViewCell
        cell.configer( self.peopleArray[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return  CGSize(width: (SCREEN_WIDTH-CGFloat(2*6))/5.0, height: 80)
        
    }
    
}
