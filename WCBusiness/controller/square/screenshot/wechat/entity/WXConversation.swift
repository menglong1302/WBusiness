//
//  WXConversation.swift
//  WCBusiness
//
//  Created by YangXL on 2017/10/26.
//  Copyright © 2017年 LYL. All rights reserved.
//

import Foundation
import RealmSwift


class WXConversation:Object{

    @objc dynamic var id = ""
    @objc dynamic var sender:Role?
    let receivers = List<Role>()
    @objc dynamic var backgroundUrl = ""
    @objc dynamic var unReadMessageNum:Int = 0
    @objc dynamic var isUseTelephoneReceiver = false
    
    @objc dynamic var isIgnoreMessage = false

    //1 代表单聊，2代表群聊
    @objc dynamic var conversationType:Int = 1
    
    @objc dynamic var groupName = "群聊"
    
    @objc dynamic var groupNum:Int = 3
    @objc dynamic var isShowGroupMemberNickName = false
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

