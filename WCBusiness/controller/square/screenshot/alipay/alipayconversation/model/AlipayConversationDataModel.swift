//
//  AlipayConversationDataModel.swift
//  WCBusiness
//
//  Created by Ray on 2017/10/23.
//  Copyright © 2017年 LYL. All rights reserved.
//

import Foundation
import RealmSwift

class AlipayConversationUser: Object {
    @objc dynamic var id = ""
    @objc dynamic var sender:Role?          //发送者
    @objc dynamic var receiver:Role?        //接受者
    @objc dynamic var backgroundImageUrl = "" // 图片url
    @objc dynamic var isDiskImage = false  //是否本地图片
    @objc dynamic var backgroundImageName = "default"  //本地图片名字
    @objc dynamic var isFriend = true       //是否为好友
    @objc dynamic var creatAt = ""          //创建时间
    override static func primaryKey() -> String? {
        return "id"
    }
}
class AlipayConversationContent: Object {
    @objc dynamic var id = ""
    @objc dynamic var contentSender:Role?
    @objc dynamic var user:AlipayConversationUser?
    @objc dynamic var type = ""         //类型
    @objc dynamic var index:Int = 0        //排序位置
    @objc dynamic var content = ""      //JSON消息内容
    @objc dynamic var transferInstructions = ""
    @objc dynamic var timeType = ""
    @objc dynamic var isRead = true     //是否已读
    @objc dynamic var creatAt = ""      //创建时间
    override static func primaryKey() -> String? {
        return "id"
    }
}
