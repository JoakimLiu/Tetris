//
//  Demo2VC.swift
//  Tetris_Example
//
//  Created by 王俊仁 on 2018/4/29.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

import UIKit
import Tetris

class Demo2VC: BaseVC, IRouterComponent {

    class var routableURL: URLPresentable {return "/demo/2"}

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        alert(msg: "\(sourceIntent!.params)")
    }

}
