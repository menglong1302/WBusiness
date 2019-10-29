//
//  TransferAccountsModel.swift
//  WCBusiness
//
//  Created by YangXL on 2017/11/9.
//  Copyright © 2017年 LYL. All rights reserved.
//

import Foundation
import ObjectMapper
class TransferAccountsModel: Mappable {
    
    //    0:转账 1：收钱
    var transferType:Int?
    
    var transferAmount:String?
    //     0:别人收我红包 1:我收别人红包
    var illustration:String?
 
    var isGetted:Bool?
    
    
    required init?(map: Map) {
        
    }
    func mapping(map: Map) {
        transferType <- map["transferType"]
        transferAmount <- map["transferAmount"]
        illustration <- map["illustration"]
        isGetted <- map["isGetted"]
    }
}
