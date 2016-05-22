//
//  ViewController.swift
//  SampleTinderUI
//
//  Created by 矢野史洋 on 2016/05/22.
//  Copyright © 2016年 矢野史洋. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let draggableBackground = DraggableViewBackground(frame: self.view.frame)
        self.view.addSubview(draggableBackground)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

