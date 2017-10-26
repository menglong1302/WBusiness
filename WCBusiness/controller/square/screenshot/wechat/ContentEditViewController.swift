//
//  ContentEditViewController.swift
//  WCBusiness
//
//  Created by YangXL on 2017/10/26.
//  Copyright © 2017年 LYL. All rights reserved.
//

import Foundation
import RealmSwift
enum EditContentType:Int {
    case UnReadMessageNum = 0
}
typealias EditContentBlock = () -> Void
class ContentEditViewController: BaseViewController {
    var conversation:WXConversation!
    var editContentType:EditContentType = .UnReadMessageNum
    var block:EditContentBlock?
    var navTitle: String?{
        didSet{
            self.navigationItem.title = navTitle
            self.textField.placeholder = "请输入\(navTitle!)"
        }
    }
    lazy var  containerView:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    lazy var textField:UITextField = {
        let field = UITextField(frame: CGRect.zero)
        field.font = UIFont.systemFont(ofSize: 14)
        field.clearButtonMode = .whileEditing
        return field
    }()
    
    lazy var barItem:UIBarButtonItem = {
        let btn = UIButton(type:.custom)
        btn.setTitle("保存", for:.normal)
        btn.contentHorizontalAlignment = .right;
        btn.translatesAutoresizingMaskIntoConstraints = false;
        btn.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, -10)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.addTarget(self, action: #selector(saveClick), for: .touchUpInside)
        return UIBarButtonItem(customView: btn)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    func  initView() {
        view.backgroundColor = UIColor.rgbq(r: 238, g: 236, b: 243, a: 1)
        navigationItem.rightBarButtonItem = barItem
        view.addSubview(containerView)
        
        containerView.addSubview(textField)
        
        containerView.snp.makeConstraints { (maker) in
            maker.left.right.equalToSuperview()
            maker.top.equalToSuperview().offset(10)
            maker.height.equalTo(50)
        }
        
        textField.snp.makeConstraints { (maker) in
            maker.left.equalToSuperview().offset(10)
            maker.right.equalToSuperview().offset(-10)
            maker.centerY.equalToSuperview()
        }
    }
    @objc  func saveClick()  {
        if let text = textField.text,!text.isEmpty{
            let realm = try! Realm()
            try!realm.write{
                switch self.editContentType{
                case .UnReadMessageNum:
                    self.conversation.unReadMessageNum =  Int((text.isPurnInt() ? text : "0"))!
                    break
                default:
                    break
                }
            }
            if (block != nil){
                block!()
            }
            self.navigationController?.popViewController(animated: true)
        }else{
            self.view.showImageHUDText("内容不能为空")
        }
    }
}
