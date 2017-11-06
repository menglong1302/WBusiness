//
//  EmojiModel.swift
//  WCBusiness
//
//  Created by YangXL on 2017/10/30.
//  Copyright © 2017年 LYL. All rights reserved.
//

import Foundation
import YYImage

class EmojiModel: NSObject {
    var image:UIImage?{
        get{
 
 
             return self.name?.getImageByName()
        }
    }
    var name:String?
    var mapperName:String?
    
}
