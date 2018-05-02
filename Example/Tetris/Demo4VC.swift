//
//  Demo4VC.swift
//  Tetris_Example
//
//  Created by 王俊仁 on 2018/5/2.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

import UIKit
import Tetris

class Demo4VC: BaseVC, URLRoutableComposable {

    static var routableURL: String {return "/demo/4"}

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "404 PAGE NOT FOUND"
        // Do any additional setup after loading the view.
    }

}

public class GlobalIntercepter: IIntercepter, Composable {

    public var priority: IntercepterPriority {return IntercepterPriority_low - 1000}

    public required init () {}

    public func doAdjudgement(_ judger: IJudger) {
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



