//
//  Demo1VC.swift
//  Tetris_Example
//
//  Created by 王俊仁 on 2018/4/29.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

import UIKit
import Tetris

class Demo1VC: BaseVC, IRouterComponent, IFinalIntercepter {

    static func finalAdjugement(_ judger: IJudger) {
        judger.doContinue()
    }


    class var routableURL: String {return "/demo/1"}


    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Demo1"
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

}
