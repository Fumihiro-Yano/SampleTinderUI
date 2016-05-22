//
//  OverlayView.swift
//  SampleTinderUI
//
//  Created by 矢野史洋 on 2016/05/22.
//  Copyright © 2016年 矢野史洋. All rights reserved.
//

import Foundation
import UIKit

enum GGOverlayViewMode: Int {
    case Left
    case Right
}

class OverlayView: UIView{
    var mode: GGOverlayViewMode?
    var imageView: UIImageView = UIImageView()
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.whiteColor()
        imageView = UIImageView(image:UIImage(named: "noButton"))
        self.addSubview(imageView)
    }
    
    func setMode(mode: GGOverlayViewMode) {
        print("load setMode")
        
        print(mode)
        if mode == GGOverlayViewMode.Left {
            imageView.image = UIImage(named: "noButton")
        } else {
            imageView.image = UIImage(named: "yesButton")
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = CGRectMake(50, 50, 100, 100)
    }
}
