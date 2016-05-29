//
//  DraggableView.swift
//  SampleTinderUI
//
//  Created by 矢野史洋 on 2016/05/22.
//  Copyright © 2016年 矢野史洋. All rights reserved.
//

import Foundation
import UIKit
let ACTION_MARGIN  = 120 //画面中央からどれだけ離れたらカードが自動的に画面から消えるかを決める。
let SCALE_STRENGTH  = 4 //カードがシュリンクするスピードを決める。
let SCALE_MAX = 0.93 //カードがどれだけ縮小するかを決める。
let ROTATION_MAX = 1 //カードの回転する大きさを決める。
let ROTATION_STRENGTH = 320
let ROTATION_ANGLE  = M_PI/8


// 後に出てくるDraggableViewBackground.swiftで使用する。カードが左右にスワイプされたときのアクションのためのプロトコル。
protocol DraggableViewDelegate  {
    func cardSwipedLeft(card: UIView)
    func cardSwipedRight(card: UIView)
}



class DraggableView: UIView {
    
    var delegate: DraggableViewDelegate?
    var information: UILabel = UILabel()
    var overlayView: OverlayView?
    var panGestureRecognizer: UIPanGestureRecognizer?
    var originalPoint: CGPoint = CGPoint()
    
    var xFromCenter: CGFloat = CGFloat()
    var yFromCenter: CGFloat = CGFloat()
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
        information = UILabel(frame:CGRectMake(0, 50, self.frame.size.width, 100))
        information.text = "no info given"
        information.textAlignment = NSTextAlignment.Center
        information.textColor = UIColor.blackColor()
        
        self.backgroundColor = UIColor.blackColor()
        
        //pan(drag)されたことを認識する
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: Selector("beingDragged:"))
        self.addGestureRecognizer(panGestureRecognizer!)
        self.addSubview(information)
        
        overlayView = OverlayView(frame: CGRectMake(self.frame.size.width/2-100, 0, 100, 100))
        overlayView!.alpha = 0
        self.addSubview(overlayView!)
        
    }
    
    func setupView() {
        self.layer.cornerRadius = 4
        self.layer.shadowRadius = 3
        self.layer.shadowOpacity = 0.2
        self.layer.shadowOffset = CGSizeMake(1, 1)
    }
    
    func beingDragged(gestureRecognizer: UIPanGestureRecognizer) {
        
        let xFromCenter = gestureRecognizer.translationInView(self).x
        let yFromCenter = gestureRecognizer.translationInView(self).y
        
        switch (gestureRecognizer.state) {
        case UIGestureRecognizerState.Began:
            //self.centerでframeのcenter(center is center of frame. animatable)
            self.originalPoint = self.center;
            break;
        case UIGestureRecognizerState.Changed:
            let rotationStrength: CGFloat = min(xFromCenter / CGFloat(ROTATION_STRENGTH), CGFloat(ROTATION_MAX))
            let rotationAngel: CGFloat = CGFloat(ROTATION_ANGLE) * rotationStrength
            let scale: CGFloat = max(1 - CGFloat(fabsf(Float(rotationStrength))) / CGFloat(SCALE_STRENGTH), CGFloat(SCALE_MAX))
            //ドラック中の中心を変更する。
            self.center = CGPointMake(self.originalPoint.x + xFromCenter, self.originalPoint.y + yFromCenter)
            //カードが少し回転する。
            let transform: CGAffineTransform = CGAffineTransformMakeRotation(rotationAngel)
            let scaleTransform: CGAffineTransform = CGAffineTransformScale(transform, scale, scale)
            self.transform = scaleTransform
            self.updateOverlay(xFromCenter)
            break
            
        case UIGestureRecognizerState.Ended:
            self.afterSwipeAction(xFromCenter)
            break
        case UIGestureRecognizerState.Possible:
            break
        case UIGestureRecognizerState.Cancelled:
            break
        case UIGestureRecognizerState.Failed:
            break
        }
    }
    
    func updateOverlay(distance: CGFloat) {
        if distance > 0 {
            overlayView!.setMode(GGOverlayViewMode.Right)
        } else {
            overlayView!.setMode(GGOverlayViewMode.Left)
        }
        
        overlayView!.alpha = min(CGFloat(fabsf(Float(distance))/100), 0.4)
    }
    
    func afterSwipeAction(xFromCenter: CGFloat) {
        if xFromCenter > CGFloat(ACTION_MARGIN) {
            self.rightAction()
        } else if xFromCenter < CGFloat(-ACTION_MARGIN) {
            self.leftAction()
        } else {
            UIView.animateWithDuration(0.3, animations: {
                self.center = self.originalPoint
                self.transform = CGAffineTransformMakeRotation(0)
                self.overlayView!.alpha = 0
            })
        }
        
    }
    
    func rightAction() {
        let finishPoint: CGPoint = CGPointMake(500, 2*yFromCenter + self.originalPoint.y)
        UIView.animateWithDuration(0.3, animations: {
            self.center = finishPoint
            }, completion: { (value: Bool) in
                self.removeFromSuperview()
        })
        delegate?.cardSwipedRight(self)
        NSLog("YES")
    }
    
    func leftAction() {
        let finishPoint: CGPoint = CGPointMake(-500, 2*yFromCenter + self.originalPoint.y)
        UIView.animateWithDuration(0.3, animations: {
            self.center = finishPoint
            }, completion: { (value: Bool) in
                self.removeFromSuperview()
        })
        delegate?.cardSwipedLeft(self)
        NSLog("NO")
    }
    
    func rightClickAction() {
        let finishPoint: CGPoint = CGPointMake(600, self.center.y)
        UIView.animateWithDuration(0.3, animations: {
            self.center = finishPoint
            self.transform = CGAffineTransformMakeRotation(1)
            }, completion: { (value: Bool) in
                self.removeFromSuperview()
        })
        delegate?.cardSwipedRight(self)
        NSLog("YES")
    }
    func leftClickAction() {
        let finishPoint: CGPoint = CGPointMake(-600, self.center.y)
        UIView.animateWithDuration(0.3, animations: {
            self.center = finishPoint
            self.transform = CGAffineTransformMakeRotation(-1)
            }, completion: { (value: Bool) in
                self.removeFromSuperview()
        })
        delegate?.cardSwipedRight(self)
        NSLog("NO")
    }
    
}