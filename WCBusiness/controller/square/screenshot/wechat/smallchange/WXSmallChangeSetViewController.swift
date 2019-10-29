//
//  WXSmallChangeSetViewController.swift
//  WCBusiness
//
//  Created by YangXL on 2017/11/27.
//  Copyright © 2017年 LYL. All rights reserved.
//

import Foundation
import ChameleonFramework
import YYText
class WXSmallChangeSetViewController: BaseViewController {
    lazy var tableView:UITableView = self.makeTableView()
    lazy var footerBtn:UIButton = self.makeFooterView()
    var amountView:YYTextView?
    var tempString:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "微信零钱设置"
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
        let footerView = UIView()
        footerView.addSubview(footerBtn)
        tableView.tableFooterView = footerView
        footerView.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 44)
        self.footerBtn.snp.makeConstraints { (maker) in
            maker.left.equalToSuperview().offset(10)
            maker.right.equalToSuperview().offset(-15)
            maker.height.equalTo(44)
            maker.top.equalTo(20)
        }
    }
    
    
    func makeTableView() -> UITableView {
        let tableView = UITableView(frame: CGRect.zero)
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = UIColor.rgbq(r: 238, g: 236, b: 243, a: 1)
        tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0 )
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInset = UIEdgeInsetsMake(10, 0, 0, 0)
        tableView.estimatedRowHeight = 50
        tableView.rowHeight = UITableViewAutomaticDimension
        
         tableView.register(WXRedPacketContentTableViewCell.self, forCellReuseIdentifier: "contentCellId")
        
        return tableView
    }
    func makeFooterView() -> UIButton {
        let btn = UIButton()
        btn.setTitle("生成预览", for: .normal)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.backgroundColor = HexColor("ff6633")
        btn.layer.cornerRadius = 3
        btn.layer.masksToBounds = true
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        btn.addTarget(self, action: #selector(generate(_:)), for: .touchUpInside)
        return btn
    }
     @objc func generate(_ btn:UIButton)  {
        guard let text =  self.amountView?.text ,!(text.isEmpty) else{
            self.view.showImageHUDText("红包金额不能为空，请输入金额")
            return
        }
        
 
         if let text =  self.amountView?.text{
            guard text.isPurnFloat() else{
                self.view.showImageHUDText("红包金额只能是数字")
                return
            }
            self.tempString =  String(format: "%.2f", Double(text)!)
        }
        
        let vc = WXSmallChangePreviewViewController()
        vc.amount = self.tempString
        present( WXBaseNavigationViewController(rootViewController: vc), animated: true, completion: nil)
        
    }
}

extension WXSmallChangeSetViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "contentCellId") as! WXRedPacketContentTableViewCell
        self.amountView = cell.textView
        self.amountView?.keyboardType = .decimalPad
        cell.textView.placeholderText = "请输入零钱金额（必填）"
        cell.selectionStyle = .none
        return cell
    }
    
}
