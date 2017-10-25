//
//  NameEditViewController.swift
//  WCBusiness
//
//  Created by YangXL on 2017/10/19.
//  Copyright © 2017年 LYL. All rights reserved.
//

import Foundation
import UIKit
import ChameleonFramework
typealias NameBlock = (String) -> ()

class NameEditViewController: BaseViewController {
    var nameBlock:NameBlock?
    var tempName:String?{
        didSet{
            textField.text = tempName
        }
    }
    var role:Role! {
        didSet(value){
            textField.text = role.nickName
        }
    }
    
    lazy var container:UIView = {
        let view = UIView(frame: CGRect.zero)
        view.backgroundColor = UIColor.white
        
        return view
    }()
    lazy var textField = { () -> UITextField in
        let textField = UITextField(frame:CGRect.zero)
        textField.placeholder = "请输入昵称"
        textField.clearButtonMode = .whileEditing
        textField.returnKeyType = .done
        textField.delegate = self
        return textField
    }()
    lazy var barItem:UIBarButtonItem = {
        let btn = UIButton(type:.custom)
        btn.setTitle("保存", for:.normal)
        btn.contentHorizontalAlignment = .right;
        btn.translatesAutoresizingMaskIntoConstraints = false;
        btn.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, -15)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.addTarget(self, action: #selector(saveClick), for: .touchUpInside)
        return UIBarButtonItem(customView: btn)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    func initView(){
        self.navigationItem.title = "昵称编辑"
        self.navigationItem.rightBarButtonItem = barItem
        self.view.backgroundColor = HexColor("EFEFEF")
        self.view.addSubview(container)
        container.addSubview(textField)
        container.snp.makeConstraints { (maker) in
            maker.left.right.equalToSuperview()
            maker.top.equalToSuperview().offset(10)
            maker.height.equalTo(44)
        }
        textField.snp.makeConstraints { (maker) in
            maker.left.equalToSuperview().offset(15)
            maker.right.equalToSuperview()
            maker.height.equalTo(30)
            maker.centerY.equalToSuperview()
        }
    }
    @objc func saveClick(){
        textField.resignFirstResponder()
        guard let _ = textField.text else {
            return
        }
        if   nameBlock != nil&&textField.text != nil{
            nameBlock!(textField.text!)
            
            self.navigationController?.popViewController(animated: true)
            
        }else{
            
        }
    }
}
extension NameEditViewController:UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
