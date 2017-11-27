//
//  WXRedPacketSetModel.swift
//  WCBusiness
//
//  Created by YangXL on 2017/11/27.
//  Copyright © 2017年 LYL. All rights reserved.
//

import Foundation
import ObjectMapper
class WXRedPacketSetModel: Mappable {
    
    var role:Role?
    var amount:String?
    var describe:String?
    
    init() {
        
    }
    
    required init?(map: Map) {
        
    }
    func mapping(map: Map) {
        role <- map["role"]
        amount <- map["amount"]
        describe <- map["describe"]
 
    }
}
