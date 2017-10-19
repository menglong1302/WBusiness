//
//  CommonUtil.swift
//  WCBusiness
//
//  Created by YangXL on 2017/10/12.
//  Copyright © 2017年 LYL. All rights reserved.
//

import UIKit

public let SCREEN_WIDTH=UIScreen.main.bounds.size.width
public let SCREEN_HEIGHT=UIScreen.main.bounds.size.height

extension String {
    public  func localPath() -> String {
        var path = NSHomeDirectory() + "/Documents/"
        path.append(self)
        return path
        
    }
}
