//
//  FileSetingViewController.swift
//  WCBusiness
//
//  Created by YangXL on 2017/10/30.
//  Copyright © 2017年 LYL. All rights reserved.
//


import YYText
import RealmSwift
import PGActionSheet
class WXTimeViewController: BaseViewController {
    
    var block:ContentBlock?
     var tempString:String?
     lazy var tableView:UITableView = {
        let tableView = UITableView(frame: CGRect.zero)
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = UIColor.rgbq(r: 238, g: 236, b: 243, a: 1)
        tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0 )
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 50
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.register(WXTimerTableViewCell.self, forCellReuseIdentifier: "timerCellId")
        tableView.register(WXTimerSystemTableViewCell.self, forCellReuseIdentifier: "timerSystemCellId")

         return tableView
    }()
    lazy var dataPicker:UIDatePicker = {
       let picker = UIDatePicker(frame: CGRect.zero)
        picker.backgroundColor = UIColor.lightGray
        picker.datePickerMode = .dateAndTime
        picker.locale = Locale(identifier: "zh_CN")
        picker.addTarget(self, action: #selector(pickerSelect(_:)), for: .valueChanged)
        return  picker
    }()
    var type:ToolType?
    var conversation:WXConversation?{
        didSet{
            if type == nil || type ==  .Create {
                
                let now = Date()

                self.tempString = "{\"timerType\":0,\"timer\":\"\(now.getStringDateFrom12())\",\"time\":\(now.timeIntervalSince1970)}"
                timer =  TimeModel(JSONString: self.tempString!)
                self.tableView.reloadData()
            }
        }
    }
    var conversationType:ConversationType?
    var contentEnumType:ContentEnumType?
    var timer:TimeModel?
    var contentEntity:WXContentEntity = WXContentEntity(){
        didSet{
            tempString = contentEntity.content
            timer =  TimeModel(JSONString: self.tempString!)
            
         }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
    }
    
    func initView()  {
        
        
        self.view.backgroundColor = UIColor.rgbq(r: 238, g: 236, b: 243, a: 1)
        self.navigationItem.title = "时间设置"
        self.rightTitle = "保存"
        self.view.addSubview(self.tableView)
        self.view.addSubview(self.dataPicker)
        self.tableView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
        
        self.dataPicker.snp.makeConstraints { (maker) in
            maker.left.right.bottom.equalToSuperview()
            maker.height.equalTo(200)
        }
        
        self.automaticallyAdjustsScrollViewInsets = false
    }
    override func rightBtnClick(_ sender: UIButton) {
        
        
        let realm = try! Realm()
        
        try! realm.write {
            contentEntity.content = (self.timer?.toJSONString())!
             if self.type == .Create || self.type == nil{
                let entities = realm.objects(WXContentEntity.self).filter("parent.id = %@",self.conversation?.id ?? "")
                contentEntity.index = entities.count+1
                contentEntity.parent = conversation
                contentEntity.id = UUID().uuidString
                contentEntity.contentType = 6
                realm.create(WXContentEntity.self, value: contentEntity, update: false)
                
            }
        }
        if block != nil {
            block!()
        }
        self.navigationController?.popViewController(animated: true)
    }
    @objc func  pickerSelect(_ picker:UIDatePicker){
        if self.timer?.timerType == 0{
            self.timer?.timer =  picker.date.getStringDateFrom12()
            self.timer?.time = picker.date.timeIntervalSince1970
        }else{
            self.timer?.timer =  picker.date.getStringDateFrom24()
            self.timer?.time = picker.date.timeIntervalSince1970
        }
        self.tableView.reloadData()
    }
    
}
extension WXTimeViewController:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "timerCellId") as! WXTimerTableViewCell
            cell.timerLabel.text = self.timer?.timer
            cell.selectionStyle = .none
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "timerSystemCellId") as! WXTimerSystemTableViewCell
            cell.block = {
                [unowned self] in
                self.tableView.reloadData()
            }
            cell.configer(self.timer!)
            cell.selectionStyle = .none
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
 
        
    }
    
}




