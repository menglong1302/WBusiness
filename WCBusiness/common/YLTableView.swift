//
//  YLTableView.swift
//  YLTableView
//
//  Created by YangXL on 2017/11/10.
//  Copyright © 2017年 LYL. All rights reserved.
//

import Foundation
import UIKit

@objc protocol YLTableViewDelegate {
 
     @objc optional func tableView(_ tableView:YLTableView,canMoveYlForIndexPath indexPath:IndexPath) -> Bool
    
}
protocol YLTableViewDataSource:UITableViewDataSource {
    func dataSourceArrayInTableView(_ tableView:YLTableView) -> Array<AnyObject>
    func tableView(_ tableView:YLTableView,newDataSourceArrayAfterMove newDataSourceArray:Array<AnyObject>)
}

class YLTableView: UITableView {
    lazy var gesture:UILongPressGestureRecognizer = {
        let ge = UILongPressGestureRecognizer(target: self, action: #selector(processGesture(_:)))
        ge.minimumPressDuration = 0.5
        return ge
    }()
    var selectedIndexPath:IndexPath?
    var isArrowCrossSection = true
    var tempArray:Array<AnyObject>?
    var tempView:UIView?
    var onlyChangeSelectIndexPath:IndexPath?
    
    open weak  var ylDelegate:YLTableViewDelegate?
    open  weak var ylDataSource:YLTableViewDataSource?
    
    var gestureMinimumPressDuration:Float?
    
    var displayLinkTimer:CADisplayLink? = nil
    
    var  scrollMinY:Float = 150.0
    
    
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        initGesture()
    }
    func initGesture(){
        self.addGestureRecognizer(gesture)
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    @objc func processGesture(_ gesture:UILongPressGestureRecognizer){
        switch gesture.state {
        case .began:
            yl_gestureBegan(gesture)
            break
        case .changed:
            yl_gestureChange(gesture)
            break
        case .ended:
            fallthrough
        case .cancelled:
            yl_gestureEnd(gesture)
            break
        default:
            break
        }
    }
    
    func yl_gestureBegan(_ gesture:UILongPressGestureRecognizer) {
        let point = gesture.location(in:self)
        let tempIndexPath = self.indexPathForRow(at: point)
        guard let _ = tempIndexPath else {
            return
        }
        if  let flag =  (self.ylDelegate?.tableView!(self, canMoveYlForIndexPath: tempIndexPath!)),!flag {
            return
        }
        jx_startEdgeScroll()
        selectedIndexPath = tempIndexPath;
        tempArray = self.ylDataSource?.dataSourceArrayInTableView(self)
        let cell = self.cellForRow(at: selectedIndexPath!  as IndexPath)!
        cell.selectionStyle = .none
        tempView = snapshotWithInputView(cell)
        tempView?.layer.shadowColor = UIColor.lightGray.cgColor;
        tempView?.layer.masksToBounds = true;
        tempView?.layer.cornerRadius = 0;
        tempView?.layer.shadowOffset = CGSize(width: -5, height: 0);
        tempView?.layer.shadowOpacity = 0.4;
        tempView?.layer.shadowRadius = 5;
        tempView?.frame = cell.frame
        self.addSubview(tempView!)
        cell.isHidden = true;
        
        UIView.animate(withDuration: 0.3) {
            self.tempView?.center = CGPoint(x: self.tempView!.center.x, y: point.y)
        }
        
    }
    func yl_gestureChange(_ gesture:UILongPressGestureRecognizer) {
        let point = gesture.location(in: gesture.view)
        let currentIndexPath = self.indexPathForRow(at: point)
        if self.isArrowCrossSection || currentIndexPath?.section == selectedIndexPath?.section{
            if currentIndexPath != nil && (selectedIndexPath != currentIndexPath) {
                
                self.yl_updateDataSourceAndCellFromIndexPath(selectedIndexPath!, toIndexPath: currentIndexPath! )
                selectedIndexPath = currentIndexPath!
            }

        }
        tempView?.center = CGPoint(x:(tempView?.center.x)!, y:point.y);

    }
    func yl_gestureEnd(_ gesture:UILongPressGestureRecognizer) {
        jx_stopEdgeScroll()
        let cell = self.cellForRow(at: selectedIndexPath!)

        
        UIView.animate(withDuration: 0.5, animations: {
            self.tempView?.frame = (cell?.frame)!
        }) { (bl) in
            cell?.isHidden = false
            self.tempView?.removeFromSuperview()
            self.tempView = nil
            self.ylDataSource?.tableView(self, newDataSourceArrayAfterMove: self.tempArray!)
        }
        
    }
    func yl_updateDataSourceAndCellFromIndexPath(_ fromIndexPath: IndexPath, toIndexPath: IndexPath)  {
        if  let _  = onlyChangeSelectIndexPath {
               (tempArray![fromIndexPath.row],tempArray![toIndexPath.row]) = (tempArray![toIndexPath.row],tempArray![fromIndexPath.row])
            self.beginUpdates()
            self.moveRow(at: fromIndexPath , to: toIndexPath )
            self.endUpdates()

        }else{
            if self.numberOfSections == 1 {
                (tempArray![fromIndexPath.row],tempArray![toIndexPath.row]) = (tempArray![toIndexPath.row],tempArray![fromIndexPath.row])
                self.moveRow(at: fromIndexPath , to: toIndexPath )
            }else{
                var fromArray = tempArray![fromIndexPath.section] as! Array<AnyObject>;
                let fromData = fromArray[fromIndexPath.row]
                var toArray = tempArray![toIndexPath.section] as! Array<AnyObject>
                let  toData = toArray[toIndexPath.row]
                fromArray[fromIndexPath.row] = toData
                toArray[toIndexPath.row] = fromData
                self.beginUpdates()
                self.moveRow(at: fromIndexPath, to: toIndexPath)
                self.moveRow(at: toIndexPath, to: fromIndexPath)
                self.endUpdates()
                
            }
        }
        
       
    }
    
    func snapshotWithInputView(_ inputView:UIView) -> UIImageView {
        UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, false, 0)
        inputView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        let imageView = UIImageView(image: image)
        return imageView
    }
    
    func jx_startEdgeScroll()
    {
        displayLinkTimer = CADisplayLink(target: self, selector: #selector(jx_Scroll))
        displayLinkTimer?.add(to: RunLoop.current, forMode: .commonModes)
    }
    
    func jx_stopEdgeScroll()
    {
        guard let _ = displayLinkTimer else{
            return
        }
        displayLinkTimer?.invalidate()
        displayLinkTimer = nil
        
    }
    @objc func jx_Scroll(){
        
//        let point = gesture.location(in: gesture.view)
//        let currentIndexPath = self.indexPathForRow(at: point)
//        if self.isArrowCrossSection || currentIndexPath?.section == selectedIndexPath?.section{
//            if currentIndexPath != nil && (selectedIndexPath != currentIndexPath) {
//
//                self.yl_updateDataSourceAndCellFromIndexPath(selectedIndexPath!, toIndexPath: currentIndexPath! )
//                selectedIndexPath = currentIndexPath!
//
//
//            }
//            tempView?.center = CGPoint(x:(tempView?.center.x)!, y:point.y);
//
//        }
//
        
        let minOffsetY = self.contentOffset.y + CGFloat(scrollMinY)
        let maxOffsetY = self.contentOffset.y + self.bounds.height - CGFloat(scrollMinY)
        let  touchPoint =  tempView?.center
        
        
        if (touchPoint!.y < CGFloat(scrollMinY)) {
            if (self.contentOffset.y < 1) {
                return;
            }else {
                self.setContentOffset(CGPoint(x: self.contentOffset.x, y: self.contentOffset.y - 1), animated:false)
                tempView!.center = CGPoint(x:tempView!.center.x, y:tempView!.center.y - 1);
            }
        }
        if (touchPoint!.y > self.contentSize.height - CGFloat(scrollMinY)) {
            if (self.contentOffset.y >= self.contentSize.height - self.bounds.size.height) {
                return;
            }else {
                if (self.contentOffset.y + 1 > self.contentSize.height - self.bounds.size.height) {
                    return;
                }
                self.setContentOffset(CGPoint(x: self.contentOffset.x, y: self.contentOffset.y + 1), animated: false)
                tempView!.center = CGPoint(x:tempView!.center.x, y:tempView!.center.y + 1);
            }
        }
        
        let maxMoveDistance:Float = 20
        
        if touchPoint!.y < minOffsetY{
            let moveDistance = (minOffsetY - touchPoint!.y)/CGFloat(scrollMinY)*CGFloat(maxMoveDistance)
            self.setContentOffset(CGPoint(x: self.contentOffset.x, y: self.contentOffset.y - moveDistance), animated: false)
            tempView!.center = CGPoint(x: (tempView?.center.x)!, y: tempView!.center.y - moveDistance)
        }else if (touchPoint?.y)! > maxOffsetY{
            let moveDistance = (touchPoint!.y - maxOffsetY)/CGFloat(scrollMinY)*CGFloat(maxMoveDistance);
            self.setContentOffset(CGPoint(x: self.contentOffset.x, y: self.contentOffset.y + moveDistance), animated: false)
            tempView!.center = CGPoint(x:tempView!.center.x, y:tempView!.center.y + moveDistance);
        }
        
        
    }
}














