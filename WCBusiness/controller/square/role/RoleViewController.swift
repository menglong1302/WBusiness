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
typealias RoleSelectBlock = (Role) -> ()
class RoleViewController: BaseViewController {
    var operatorType:OperatorType? = .Edit
    var roleSelectBlock:RoleSelectBlock?
    lazy var tableView = UITableView()
    lazy var dataArray = [String:[Role]]()
    lazy var keyArray = [[String:Int]]()
    lazy var keys = [String]()
    var tempRole:Role?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.navigationItem.title = "角色库"
        initView()
        fetchData()
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
        let btn = UIButton(type: .custom)
        btn.setTitle("新建", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.contentHorizontalAlignment = .right;
        btn.translatesAutoresizingMaskIntoConstraints = false;
        btn.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, -10)
        btn.addTarget(self, action: #selector(addRole), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: btn)
    }
    @objc func addRole(){
        let addVC = AddRoleViewController()
        addVC.block = {
            [weak self] in
            DispatchQueue.main.async{
                self?.fetchData()
                self?.tableView.reloadData()
                
            }
        }
        present(UINavigationController(rootViewController: addVC), animated: true, completion: nil)
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
        let meArray = dataArray.removeValue(forKey: "我")
        let temp =  dataArray.sorted { (t1, t2) -> Bool in
            return   t1.key < t2.key ? true:false
        }
        
        for data in temp{
            keyArray.append([data.0 : data.1.count])
            keys.append(data.0)
        }
        if let array = meArray,array.count>0 {
            keyArray.insert(["我":array.count], at: 0)
            keys.insert("我", at: 0)
            dataArray["我"] = array
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
            let key =  keyArray[indexPath.section].keys.first!
            let role =  dataArray[key]![indexPath.row]
            if let temp =  self.tempRole{
                if temp.id == role.id{
                    self.view .showImageHUDText("不能选择已经选择过的角色")
                    return
                }
            }
            
            roleSelectBlock!(role)
            self.navigationController?.popViewController(animated: true)
            break
        case .Edit:
            let roleVC =   RoleEditViewController()
            let key =  keyArray[indexPath.section].keys.first!
            let role =  dataArray[key]![indexPath.row]
            roleVC.role = role
            roleVC.block = {
                [weak self] (tempName,tempImageUrl) in
                self?.fetchData()
            }
            self.navigationController?.pushViewController(roleVC, animated: true)
            
            break
            
            
            
        }
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let key =  keyArray[indexPath.section].keys.first!
        let role =  dataArray[key]!.remove(at: indexPath.row)
        let realm = try! Realm()
        try! realm.write {
            realm.delete(role)
        }
        self.fetchData()
        
    }
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "删除"
    }
}


