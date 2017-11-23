//
//  WXImageModel.swift
//  WCBusiness
//
//  Created by YangXL on 2017/11/23.
//  Copyright © 2017年 LYL. All rights reserved.
//
import Foundation
import ObjectMapper
class WXImageModel: Mappable {
    
    // 0:12小时制 1：24小时制
    var path:String?
    
    var width:CGFloat?
    
    var height:CGFloat?
    
    init() {
    }
    required init?(map: Map) {
        
    }
    func mapping(map: Map) {
        height <- map["height"]
        width <- map["width"]
        path <- map["path"]
    }
}
