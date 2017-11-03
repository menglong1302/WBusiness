//
//  YLEmojiTabBar.swift
//  WCBusiness
//
//  Created by YangXL on 2017/11/2.
//  Copyright © 2017年 LYL. All rights reserved.
//

import Foundation
protocol YLEmojiTabBarDelegate {
    func emojiDidSelect(_ status:Int)
    func dismissKeyBoardDidSelect()

}

class YLEmojiTabBar: UIView {
    //emoji 切换
    lazy var emojiBtn = {
       () -> UIButton in
        let btn = UIButton(type: .custom)
        btn.setImage("emoji@3x".getImageByName(bundle: "emojiBarBundle"), for: .normal)
        btn.addTarget(self, action: #selector(emojiClick(_:)), for: .touchUpInside)
        return btn
    }()
    //收回键盘
    lazy var dismissKeyBoard = {
        () -> UIButton in
        let btn = UIButton(type: .custom)
        btn.setImage("emoji@3x".getImageByName(bundle: "emojiBarBundle"), for: .normal)
        btn.addTarget(self, action: #selector(dismissClick(_:)), for: .touchUpInside)

        return btn
    }()
    var delegate:YLEmojiTabBarDelegate?
    //默认状态是0：键盘状态  1：是emoji状态
    var status:Int = 0{
        didSet{
            if status == 1 {
                emojiBtn.setImage("emoji@3x".getImageByName(bundle: "emojiBarBundle"), for: .normal)
            }else{
                emojiBtn.setImage("keyboard@3x".getImageByName(bundle: "emojiBarBundle"), for: .normal)

            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initView() {
        backgroundColor = UIColor.white
        self.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 30)
        [emojiBtn,dismissKeyBoard].forEach { (view) in
            addSubview(view)
        }
        dismissKeyBoard.snp.makeConstraints { (maker) in
            maker.right.equalToSuperview().offset(-10)
            maker.centerY.equalToSuperview()
            maker.width.height.equalTo(25)
        }
        
        emojiBtn.snp.makeConstraints { (maker) in
            maker.right.equalTo(dismissKeyBoard.snp.left).offset(-10)
            maker.centerY.equalToSuperview()
            maker.width.height.equalTo(25)
        }
    }
    
    @objc func emojiClick(_ btn:UIButton ){
        if self.delegate != nil {
            status =  status == 1 ? 0 : 1
            self.delegate?.emojiDidSelect(status)
        }
    }
    @objc func dismissClick(_ btn:UIButton ){
        if self.delegate != nil {
            self.delegate?.dismissKeyBoardDidSelect()
        }
    }
}
