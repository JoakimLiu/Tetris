//
//  Demo4VC.swift
//  Tetris_Example
//
//  Created by 王俊仁 on 2018/5/2.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

import UIKit
import Tetris

class Demo4VC: BaseVC, IRouterComponent {

    static var routableURL: URLPresentable {return "/demo/4"}

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "404 PAGE NOT FOUND"
        // Do any additional setup after loading the view.
    }

}



final public class GlobalIntercepter: LowPriorityIntercepter, IModuleComponent {

    public override var priority: Prioritable {return IntercepterPriority.low.priority - 1000}

    public override func doAdjudgement(_ judger: IJudger) {
        if let _ = judger.getIntent().target {
            judger.doContinue()
        } else {
            print("-----lost-----")
            let intent = Intent.pushPop(url: "/demo/4")
            intent.displayer = judger.getIntent().displayer
            judger.doSwitch(intent)
        }
    }
}



