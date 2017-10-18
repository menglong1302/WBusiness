//
//  RoleModel.swift
//  WCBusiness
//
//  Created by YangXL on 2017/10/16.
//  Copyright © 2017年 LYL. All rights reserved.
//

import Foundation
import RealmSwift

class Role: Object {
    @objc dynamic var nickName = "" //昵称
    @objc dynamic var imageUrl = "" // 图片url
    @objc dynamic var isLocalImage = true  //是否本地图片
    @objc dynamic var isSelf = false   //是否自己
    @objc dynamic var imageName = ""  //本地图片名字
    @objc dynamic var id = ""
    @objc dynamic var firstLetter=""
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    static func initData() -> Array<String>{
        let dataArray = ["斑点水玛线","- 扯蛋 丶","想太多我会难过","童话里没有你","Abandon丶","Sunny°刺眼","So what、","焚心劫","昂贵的、背影","米兰","泡泡龙","为爱放弃","花菲","杰克","大朋友","文远","愛/heart"]
        return dataArray
    }
}
