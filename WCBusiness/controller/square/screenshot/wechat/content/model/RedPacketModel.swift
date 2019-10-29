//
//  RedModel.swift
//  WCBusiness
//
//  Created by YangXL on 2017/11/8.
//  Copyright © 2017年 LYL. All rights reserved.
//

import Foundation
import ObjectMapper
class RedPacketModel: Mappable {
    
    //    0:发红包 1：收红包
    var packetType:String?
    var content:String?
    //     0:别人收我红包 1:我收别人红包
    var receiveType:String?
    
    //     0:单聊    1：群聊
    var conversationType:String?
    
    var isGetted:Bool?
    
    
    required init?(map: Map) {
        
    }
    func mapping(map: Map) {
        packetType <- map["packetType"]
        content <- map["content"]
        receiveType <- map["receiveType"]
        conversationType <- map["conversationType"]
        isGetted <- map["isGetted"]

        
    }
}
