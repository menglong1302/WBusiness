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
    var footerView:UIView?
    var footerViewLeftBtn:UIButton?
    var footerViewRightBtn:UIButton?
    var rigthBtn:UIButton?
    let cellID = "cellID"
    //建立数据数组
    var tableData = ["宝宝0","宝宝1","宝宝2","宝宝3","宝宝4","宝宝5","宝宝6","宝宝7","宝宝8","宝宝9","宝宝10","宝宝11","宝宝12","宝宝13","宝宝14","宝宝15","宝宝16","宝宝17","宝宝18","宝宝19","宝宝20","宝宝21","宝宝22","宝宝23","宝宝24","宝宝25","宝宝26","宝宝27","宝宝28","宝宝29","宝宝30","宝宝31"];
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        self.navigationItem.title = "支付宝对话"
        initRightItem()
        initView()
        initFooterView()
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
        self.view.backgroundColor = UIColor.blue;
        //设置tableView的frame
        let tableViewHeight = self.view.frame.height-64-44;
//        print("View高度\(self.view.frame.height)");
        tableView = UITableView.init(frame:CGRect.init(x:0, y:0, width:self.view.frame.width, height:tableViewHeight),style:.grouped);
        //tableView的两个代理方法
        tableView.delegate = self;
        tableView.dataSource = self;
//        tableView.sectionHeaderHeight = 20;
        self.view.addSubview(tableView)
        tableView.reloadData()
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
    }
    func footerViewLeftBtnAction() -> Void {
        let alipayCAV = AlipayConversationAddView.init(frame: CGRect.zero);
        
        self.view.addSubview(alipayCAV);
        alipayCAV.snp.makeConstraints({(maker) in
            maker.left.bottom.right.equalToSuperview()
            maker.height.equalTo(self.view.frame.height/2)
            maker.width.equalTo(self.view.frame.width)
        })
        print("footerViewLeftBtnAction")
    }
    func footerViewRightBtnAction(button:UIButton) -> Void {
        print("footerViewRightBtnAction=\(button)")
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
        let identifier="identtifier";
        var cell=tableView.dequeueReusableCell(withIdentifier: identifier)
        if(cell == nil){
            cell=UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: identifier);
        }
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                cell?.textLabel?.text = "第一行";
                cell?.detailTextLabel?.text = "待添加";
                cell?.detailTextLabel?.font = UIFont .systemFont(ofSize: CGFloat(13))
                cell?.accessoryType=UITableViewCellAccessoryType.disclosureIndicator
            }
        
        } else {
            cell?.textLabel?.text = tableData[indexPath.row];
            cell?.detailTextLabel?.text = "待添加内容";
            cell?.detailTextLabel?.font = UIFont .systemFont(ofSize: CGFloat(13))
            cell?.accessoryType=UITableViewCellAccessoryType.disclosureIndicator
        }
        
        
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row);
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
