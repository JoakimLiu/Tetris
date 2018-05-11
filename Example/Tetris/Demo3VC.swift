//
//  Demo3VC.swift
//  Tetris_Example
//
//  Created by 王俊仁 on 2018/4/29.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

import UIKit
import Tetris

class Demo3VC: BaseVC, IRouterComponent, IFinalIntercepter {

    class var routableURL: URLPresentable {return "/demo/3"}

    class func finalAdjugement(_ judger: IJudger) {
        print("-------do some biz logic here-------")
        judger.doContinue()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}
