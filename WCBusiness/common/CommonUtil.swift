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


public let BORDER_WIDTH_1PX = UIScreen.main.scale > 0.0 ? (1.0/UIScreen.main.scale) : 1.0


extension String {
    public  func localPath() -> String {
        var path = NSHomeDirectory() + "/Documents/"
        path.append(self)
        return path
        
    }
    func isPurnInt() -> Bool {
        
        let scan: Scanner = Scanner(string: self)
        var val:Int = 0
        return scan.scanInt(&val) && scan.isAtEnd
        
    }
    func getImageByName() -> UIImage {
        var str =  Bundle.main.path(forResource: "wx_emoji", ofType: "bundle")
        str?.append("/"+self)
        return  UIImage(contentsOfFile:str!)!
    }
    func getImageNamePath() -> String {
        
        var str =  Bundle.main.path(forResource: "wx_emoji", ofType: "bundle")
        str?.append("/"+self)
        return str!
    }
    func isPurnFloat() -> Bool {
        
        let scan: Scanner = Scanner(string: self)
        
        var val:Float = 0
        
        return scan.scanFloat(&val) && scan.isAtEnd
        
    }
    
}
enum WeekDate:Int{
    case Sunday = 1,Monday,Tuesday,Wednesday,Thursday,Friday,Saturday
    func   getString() -> String{
        switch self {
        case .Sunday:
            return "星期日"
        case .Monday:
            return "星期一"
        case .Tuesday:
            return "星期二"
        case .Wednesday:
            return "星期三"
        case .Thursday:
            return "星期四"
        case .Friday:
            return "星期五"
        case .Saturday:
            return "星期六"
        }
        
    }
    
}

extension Date{
    func getStringDateFrom12() -> String {
        let calender = Calendar.current
        if calender.isDateInToday(self) {
            let components =  calender.dateComponents([.hour,.minute], from: self)
            return getStringHourAndMinute(components.hour!,components.minute!)
            
        }else{
            //判断是否大于今天
            let result = calender.compare(self, to: Date(), toGranularity: Calendar.Component.day)
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale.current
            dateFormatter.dateFormat = "yyyy日MM月dd日"
            
            
            
            print(result.rawValue)
            if result.rawValue > 0{//大于当天
                let stringDate = dateFormatter.string(from: self)
                let components =  calender.dateComponents([.hour,.minute], from: self)
                return stringDate + " " + getStringHourAndMinute(components.hour!,components.minute!)
                
                
            }else{ //小于当前时间
                let component =  calender.dateComponents([.year,.day], from:self , to:Date())
                let components =  calender.dateComponents([.hour,.minute], from: self)
                
                if calender.isDateInYesterday(self){
                    return "昨天 " + getStringHourAndMinute(components.hour!,components.minute!)
                }else  if component.year! == 0 && component.day! <= 7{ //判断是否在1星期内
                    let weekString = WeekDate(rawValue: calender.component(.weekday, from: self))?.getString()
                    return weekString! + " " + getStringHourAndMinute(components.hour!,components.minute!)
                }else{
                    let stringDate = dateFormatter.string(from: self)
                    return stringDate + " " + getStringHourAndMinute(components.hour!,components.minute!)
                }
            }
            
            
        }
        
    }
    func getStringHourAndMinute(_ hour:Int,_ minute:Int) -> String {
        return ((hour > 12 ? "下午\(hour-12):" : "上午\(hour):") + (minute <= 9 ?"0\(minute)":"\(minute)"))
    }
    
    func getStringDateFrom24() -> String {
        let calender = Calendar.current
        if calender.isDateInToday(self) {
            let components =  calender.dateComponents([.hour,.minute], from: self)
            return getString24HourMinute(components.hour!,components.minute!)
            
        }else{
            let result = calender.compare(self, to: Date(), toGranularity: Calendar.Component.day)
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale.current
            dateFormatter.dateFormat = "yyyy日MM月dd日"
            if result.rawValue > 0{//大于当天
                let stringDate = dateFormatter.string(from: self)
                let components =  calender.dateComponents([.hour,.minute], from: self)
                return stringDate + " " + getString24HourMinute(components.hour!,components.minute!)
                
                
            }else{ //小于当前时间
                let component =  calender.dateComponents([.year,.day], from:self , to:Date())
                let components =  calender.dateComponents([.hour,.minute], from: self)
                
                if calender.isDateInYesterday(self){
                    return "昨天 " + getString24HourMinute(components.hour!,components.minute!)
                }else  if component.year! == 0 && component.day! <= 7{ //判断是否在1星期内
                    let weekString = WeekDate(rawValue: calender.component(.weekday, from: self))?.getString()
                    return weekString! + " " + getString24HourMinute(components.hour!,components.minute!)
                }else{
                    let stringDate = dateFormatter.string(from: self)
                    return stringDate + " " + getString24HourMinute(components.hour!,components.minute!)
                }
            }
            
        }
        
    }
    func getString24HourMinute(_ hour:Int,_ minute:Int) -> String  {
        return (hour <= 9 ? "0\(hour)" : "\(hour)") + ":" + (minute <= 9 ?"0\(minute)":"\(minute)")
    }
    
    
}

extension UIImage{
    func imageWithScale(width:CGFloat) -> UIImage{
        if self.size.width < width{
            return self
        }
        //1.根据 宽度 计算高度
        let height = width * size.height / size.width
        //2.按照宽高比绘制一张新的图片
        let currentSize = CGSize.init(width: width, height: height)
        UIGraphicsBeginImageContext(currentSize)  //开始绘制
        draw(in: CGRect.init(origin: CGPoint.zero, size: currentSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()  //结束上下文
        return newImage!
    }
}
