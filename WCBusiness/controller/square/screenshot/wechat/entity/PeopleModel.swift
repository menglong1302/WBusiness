//
//  PeopleModel.swift
//  WCBusiness
//
//  Created by YangXL on 2017/10/27.
//  Copyright © 2017年 LYL. All rights reserved.
//

import Foundation
public class PeopleModel {
    var role:Role?
    var isAdd:Bool = false
    
    init() {
        
    }
    init(role:Role) {
        self.role = role
    }
}
