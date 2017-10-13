//
//  AlipayConversationViewController.swift
//  WCBusiness
//
//  Created by Ray on 2017/10/13.
//  Copyright © 2017年 LYL. All rights reserved.
//

import UIKit
import SnapKit
class AlipayConversationViewController : BaseViewController  {
    var tableView = UITableView()
    let cellID = "cellID"
    //建立数据数组
    var tableData = ["宝宝0","宝宝1","宝宝2","宝宝3","宝宝4","宝宝5","宝宝6","宝宝7","宝宝8","宝宝9","宝宝10","宝宝11","宝宝12","宝宝13","宝宝14","宝宝15","宝宝16","宝宝17","宝宝18","宝宝19","宝宝20","宝宝21","宝宝22","宝宝23","宝宝24","宝宝25","宝宝26","宝宝27","宝宝28","宝宝29","宝宝30","宝宝31"];
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        self.navigationItem.title = "支付宝对话"
        initView()
    }
    func initView() -> Void {
        self.view.backgroundColor = UIColor.blue;
        //设置tableView的frame
        tableView = UITableView.init(frame:CGRect.init(x:0, y:0, width:self.view.frame.width, height:self.view.frame.height),style:.plain);
        //tableView的两个代理方法
        tableView.delegate = self;
        tableView.dataSource = self;
        
        self.view.addSubview(tableView)
        tableView.reloadData()
    }
}
//talbeView 的两个代理方法的实现，其实这两个代理还能加到class声明的后面，代理方法的时候和OC里面的实现是一样的
extension AlipayConversationViewController:UITableViewDataSource,UITableViewDelegate {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row);
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50;
    }

}
