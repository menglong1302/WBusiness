//
//  TimeModel.swift
//  WCBusiness
//
//  Created by YangXL on 2017/11/9.
//  Copyright © 2017年 LYL. All rights reserved.
//

import Foundation
import ObjectMapper
class TimeModel: Mappable {
    
    // 0:12小时制 1：24小时制
    var timerType:Int?
 
    var timer:String? //显示string
    
    var time:TimeInterval? // 时间戳
    required init?(map: Map) {
        
    }
    func mapping(map: Map) {
        timerType <- map["timerType"]
        timer <- map["timer"]
        time <- map["time"]
     }
}

