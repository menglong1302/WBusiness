//
//  AlipayTransferModel.swift
//  WCBusiness
//
//  Created by Ray on 2017/11/17.
//  Copyright © 2017年 LYL. All rights reserved.
//

import Foundation
import RealmSwift
enum Enum_memberLevels:String{
    case level_1 = "无"
    case level_2 = "大众会员"
    case level_3 = "黄金会员"
    case level_4 = "铂金会员"
    case level_5 = "钻石会员"
}
enum Enum_payModes:String{
    case mode_1 = "余额"
    case mode_2 = "余额宝"
}
enum Enum_dealStatus:String{
    case dealStatus_1 = "交易成功"
    case dealStatus_2 = "交易中"
}
class AlipayTransferModel: Object {
    @objc dynamic var id = ""
    @objc dynamic var user:AlipayConversationUser?
    @objc dynamic var contentSender:Role?
    @objc dynamic var transferType = "转入"
    @objc dynamic var account = ""
    @objc dynamic var amount = ""
    @objc dynamic var instructions = ""
    var conversationMemberLevel = Enum_memberLevels.level_1
    var payMode = Enum_payModes.mode_1
    var dealStatus = Enum_dealStatus.dealStatus_1
    @objc dynamic var creatAt = ""
    override static func primaryKey() -> String? {
        return "id"
    }
}
