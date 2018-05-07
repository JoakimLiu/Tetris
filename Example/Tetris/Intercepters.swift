//
//  Intercepters.swift
//  Tetris_Example
//
//  Created by 王俊仁 on 2018/5/2.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

import Tetris

class Intercepter1: NormalPriorityIntercepter, IComponent {
    required init() {
    }
    override func doAdjudgement(_ judger: IJudger) {
        print("\(self)")
        judger.doContinue()
    }
}

class Intercepter2: HighPriorityIntercepter, IComponent {
    required init() {
    }
    override func doAdjudgement(_ judger: IJudger) {
        print("\(self)")
        judger.doContinue()
    }
}

class Intercepter4: HighPriorityIntercepter, IComponent {
    required init() {
    }
    override func doAdjudgement(_ judger: IJudger) {
        print("\(self)")
        judger.doContinue()
    }
}

class Intercepter3: LowPriorityIntercepter, IComponent {
    required init() {
    }
    override func doAdjudgement(_ judger: IJudger) {
        print("\(self)")
        judger.doContinue()
    }
}
