//
//  String+extension.swift
//  WCBusiness
//
//  Created by YangXL on 2017/11/2.
//  Copyright © 2017年 LYL. All rights reserved.
//

import Foundation
extension String{
    func getImageByName(bundle str:String) -> UIImage {
        var str =  Bundle.main.path(forResource: str, ofType: "bundle")
        str?.append("/"+self)
        return  UIImage(contentsOfFile:str!)!
    }
}
