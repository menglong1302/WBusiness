//
//  WXContentEntity.swift
//  WCBusiness
//
//  Created by YangXL on 2017/10/30.
//  Copyright © 2017年 LYL. All rights reserved.
//

import Foundation
import RealmSwift
class WXContentEntity:Object{
    
    @objc dynamic var id = ""
    @objc dynamic var sender:Role?
    @objc dynamic var parent:WXConversation?
       //1：文本，2：图片 3:语音 4：红包 5：转账 6：时间 7：系统提示
    @objc dynamic var contentType:Int = 1
    //内容
    @objc dynamic var content:String = ""
    @objc dynamic var index:Int = 0
    override static func primaryKey() -> String? {
        return "id"
    }
}
