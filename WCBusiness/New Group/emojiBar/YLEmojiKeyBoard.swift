//
//  YLEmojiBar.swift
//  WCBusiness
//
//  Created by YangXL on 2017/11/2.
//  Copyright © 2017年 LYL. All rights reserved.
//

import Foundation
import YYText
enum ContentType {
    case WeChat,Ali
}

class YLEmojiKeyBoard:NSObject {
    
    lazy var tabBar:YLEmojiTabBar = {
        let view = YLEmojiTabBar()
        view.status = 0
        view.delegate = self
        return view
    }()
    
    lazy var containerView:YLEmojiContainer = {
        let view = YLEmojiContainer(frame: CGRect.zero)
        view.collectionView.dataSource = self
        view.collectionView.delegate = self
        return view
    }()
    var yyTextView:YYTextView?{
        didSet{
            yyTextView?.inputAccessoryView = self.tabBar
        }
    }
    var type:ContentType?{
        didSet{
            self.initData()
        }
    }
    var array = [EmojiModel]()
    var sectionNum:Int? = 1
    override init() {
        super.init()
        self.initView()
    }
    func  initData(){
        
        if type == .WeChat {
            for index in 1...114{
                let model = EmojiModel()
                model.name = "Expression_"+String(index)+".png"
                model.mapperName = ":100\(index):"
                array.append(model)
            }
            self.sectionNum = array.count%24 == 0 ? Int(array.count/24):Int(ceil(CGFloat(array.count)/24.0))
        }else{
            
        }
    }
    func initView(){
        
    }
    
}
extension YLEmojiKeyBoard:YLEmojiTabBarDelegate{
    func emojiDidSelect(_ status:Int){
        if  status == 1 {//emoji
            
            
            UIView.animate(withDuration: 0.1, animations: {
                self.yyTextView?.inputView = self.containerView
                self.yyTextView?.resignFirstResponder()
            }, completion: { (bl) in
                self.yyTextView?.becomeFirstResponder()
            })
        }else{//keyboard
            UIView.animate(withDuration: 0.1, animations: {
                self.yyTextView?.inputView = nil
                self.yyTextView?.resignFirstResponder()
            }, completion: { (bl) in
                self.yyTextView?.becomeFirstResponder()
            })
            
        }
    }
    func dismissKeyBoardDidSelect(){
        yyTextView?.resignFirstResponder()
    }
}
extension YLEmojiKeyBoard:UICollectionViewDataSource,UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 24
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "emojiCollectionCellId", for: indexPath) as! WXEmojiCollectionViewCell
        
        
        if indexPath.item == 23 {
            cell.isLast = true
        }else{
            let model = _emoticonForIndexPath(indexPath)
            if model == nil{
                cell.isUserInteractionEnabled = false
            }else{
                cell.isUserInteractionEnabled = true
            }
            cell.imageView.image = model?.image
        }
        
        return cell
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.sectionNum!
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: false)
        
        if indexPath.item == 23 {
            self.yyTextView?.deleteBackward()
            return
        }
        let model = _emoticonForIndexPath(indexPath)
        if model != nil {
            let location = self.yyTextView?.selectedRange.location
            self.yyTextView?.resignFirstResponder()
            let  str = NSMutableAttributedString(attributedString: (self.yyTextView?.attributedText)!)
            str.insert( NSMutableAttributedString.yy_attachmentString(withEmojiImage: model!.image!, fontSize: 14)!, at: location!)
            self.yyTextView?.attributedText = str
            self.yyTextView?.scrollRangeToVisible(NSMakeRange(location!+1, 0))
            self.yyTextView?.selectedRange = NSMakeRange(location!+1, 0)
        }
        //        let location = self.textView?.selectedRange.location
        //        self.textView?.resignFirstResponder()
        //        let  str = NSMutableAttributedString(attributedString: (self.textView?.attributedText)!)
        //        str.insert( NSMutableAttributedString.yy_attachmentString(withEmojiImage: model.image!, fontSize: 14)!, at: location!)
        //        self.textView?.attributedText = str
        //        self.textView?.scrollRangeToVisible(NSMakeRange(location!+1, 0))
        //        self.textView?.selectedRange = NSMakeRange(location!+1, 0)
        
    }
    func _emoticonForIndexPath(_ indexPath:IndexPath) -> EmojiModel? {
        let  section = indexPath.section
        var index = 23*section+indexPath.item
        
        let ip = index / 23;
        let  ii = index % 23;
        let reIndex = (ii % 3) * 8 + (ii / 3);
        index = reIndex + ip * 23;
        
        if index>=114 {
            return nil
        }
        return array[index]
    }
}
