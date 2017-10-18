//
//  AppDelegate.swift
//  WCBusiness
//
//  Created by YangXL on 2017/10/11.
//  Copyright © 2017年 LYL. All rights reserved.
//

import UIKit
import RealmSwift
import  SwiftyUserDefaults
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow.init(frame:UIScreen.main.bounds)
        window?.rootViewController = WBTabBarController()
        window?.makeKeyAndVisible()
        //数据库初始化
        realmDB()
        
        initData();
        
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    //初始化数据库
    func realmDB()  {
        var config = Realm.Configuration()
        
        // 使用默认的目录，但是使用用户名来替换默认的文件名
        config.fileURL = config.fileURL!.deletingLastPathComponent()
            .appendingPathComponent("WCBusiness.realm")
        config.schemaVersion = 1
        // 将这个配置应用到默认的 Realm 数据库当中
        Realm.Configuration.defaultConfiguration = config
    }
    //添加初始化数据
    func initData() {
        
        let userDefault = UserDefaults.standard
        let isFirst:Bool? = userDefault.hasKey("isDBInit")
        //存在first 并且first = true
        DispatchQueue.global().async{
 
            let realm = try! Realm()
            if let first = isFirst ,!first{
                
                let roleArray =  Role.initData()
                for (index,name) in roleArray.enumerated(){
                    let role = Role()
                    role.id = UUID().uuidString
                    role.nickName = name
                    role.imageName = "Image-\(index+1)"
                    role.isLocalImage = true
                    role.isSelf = false
                    role.imageUrl = ""
                    role.firstLetter =  name.getFirstLetterFromString()
                    try! realm.write{
                        realm.create(Role.self, value: role, update: false)
                    }
                }
                
                
                DispatchQueue.main.async {
                    userDefault.set(true, forKey: "isDBInit")

                }
            }
        }
        
        userDefault.synchronize()
    }
 
}

extension String{
    
    
    func getFirstLetterFromString() -> (String) {
        
        // 注意,这里一定要转换成可变字符串
        let mutableString = NSMutableString.init(string: self)
        // 将中文转换成带声调的拼音
        CFStringTransform(mutableString as CFMutableString, nil, kCFStringTransformToLatin, false)
        // 去掉声调(用此方法大大提高遍历的速度)
        let pinyinString = mutableString.folding(options: String.CompareOptions.diacriticInsensitive, locale: NSLocale.current)
        // 将拼音首字母装换成大写
        let strPinYin = pinyinString.uppercased()
        // 截取大写首字母
        let firstString = strPinYin.substring(to: strPinYin.index(strPinYin.startIndex, offsetBy:1))
        // 判断姓名首位是否为大写字母
        let regexA = "^[A-Z]$"
        let predA = NSPredicate.init(format: "SELF MATCHES %@", regexA)
        return predA.evaluate(with: firstString) ? firstString : "#"
    }
}
