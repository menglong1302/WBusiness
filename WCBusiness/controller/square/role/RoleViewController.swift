//
//  RoleViewController.swift
//  WCBusiness
//
//  Created by YangXL on 2017/10/17.
//  Copyright © 2017年 LYL. All rights reserved.
//

import UIKit
import RealmSwift
import SnapKit
enum OperatorType:Int {
    case Select = 1,Edit
}

class RoleViewController: BaseViewController {
    var operatorType:OperatorType?
    
    lazy var tableView = UITableView()
    lazy var dataArray = [String:[Role]]()
    lazy var keyArray = [[String:Int]]()
    lazy var keys = [String]()
   
     override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.navigationItem.title = "角色库"
        initView()
        fetchData()
        operatorType = .Edit
      
    }
    func initView() {
        tableView = UITableView.init(frame: CGRect.zero, style: .plain)
        self.view.addSubview(tableView)
        tableView.backgroundColor = UIColor.white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(RoleTableViewCell.self, forCellReuseIdentifier: "tableCellId")
        tableView.snp.makeConstraints { (makder) in
            makder.left.top.right.bottom.equalToSuperview()
        }
        
    }
    func fetchData(){
        dataArray.removeAll()
        keyArray.removeAll()
        keys.removeAll()
        
        let realm = try! Realm()
        let roles = realm.objects(Role.self)
        for role in roles{
            var letter:String?
            if role.isSelf {
                letter = "我"
            }else{
                letter = role.firstLetter
            }
            if let _ =  dataArray[letter!]{} else{
                dataArray[letter!] = [Role]()
                
            }
            dataArray[letter!]!.append(role)
        }
        let temp =  dataArray.sorted { (t1, t2) -> Bool in
            return   t1.key < t2.key ? true:false
        }
        
        for data in temp{
            keyArray.append([data.0 : data.1.count])
            keys.append(data.0)
        }
        self.tableView.reloadData()
    }
    
    
    
    
}

extension RoleViewController:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  keyArray[section].values.first!;
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCellId") as! RoleTableViewCell
        let key =  keyArray[indexPath.section].keys.first!
        let role =  dataArray[key]![indexPath.row]
        cell.setModel(role)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50;
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return keyArray.count
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return  keyArray[section].keys.first!
    }
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return keys
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch operatorType! {
        case .Select:
            break
        case .Edit:
              let roleVC =   RoleEditViewController()
              let key =  keyArray[indexPath.section].keys.first!
              let role =  dataArray[key]![indexPath.row]
              roleVC.role = role
              self.navigationController?.pushViewController(roleVC, animated: true)
 
            break
            
        
            
        }
    }
}


