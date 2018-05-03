//
//  Injection.swift
//  Tetris_Example
//
//  Created by 王俊仁 on 2018/5/3.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

import Foundation
import Swinject
import Tetris

protocol AProtocol {
    func methodA()
}

class AImpl : AProtocol {
    func methodA() {
        print("aimpl \(#function)")
    }
}


class InjectionModule: LowPriorityModule, IComponent {

    let container = Container.init()

    let aimpl = AImpl()

    override func modulerInit(_ context: Context) {
        container
            .register(AProtocol.self) { (r) in AImpl()}
    }

    override func modulerSetup(_ context: Context) {
        let a = container.resolve(AProtocol.self)
        a?.methodA()
        let b = container.resolve(AProtocol.self)
        b?.methodA()
    }
}



