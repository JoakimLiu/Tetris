//
//  GlobalIntercepter.swift
//  Tetris_Example
//
//  Created by 王俊仁 on 2018/5/2.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

import Tetris

public class GlobalIntercepter: IIntercepter, Component {

    public var priority: IntercepterPriority {return IntercepterPriority_low - 1000}

    public required init () {}

    public func doAdjudgement(_ judger: IIntercepterJudger) {
        if let _ = judger.getIntent().target {
            judger.doContinue()
        } else {
            print("-----lost-----")
            judger.doReject(["info": "lost"])
        }
    }
}
