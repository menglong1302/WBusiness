//
//  UIColor+extension.swift
//  YLImagePicker
//
//  Created by YangXL on 2017/10/23.
//  Copyright © 2017年 LYL. All rights reserved.
//

import Foundation
import UIKit
extension UIColor{
    open static func   rgbq(r:CGFloat,g g:CGFloat,  b b:CGFloat , a  a:CGFloat) -> UIColor{
        return UIColor.init(red: r/255, green: g/255, blue: b/255, alpha: a)
    }
}
