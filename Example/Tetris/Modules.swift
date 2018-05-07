//
//  Modules.swift
//  Tetris_Example
//
//  Created by 王俊仁 on 2018/4/28.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

import Foundation
import Tetris

class HighModule: HighPriorityModule, IModuleComponent {

    override func modulerInit(_ context: Context) {
        print("\(self)   \(#function)")
    }
}

class NormalModule: NormalPriorityModule, IModuleComponent {

    override func modulerInit(_ context: Context) {
        print("\(self)   \(#function)")
    }
}

class LowModule: LowPriorityModule, IModuleComponent {

    override func modulerInit(_ context: Context) {
        print("\(self)   \(#function)")
        let a: Service1? = Tetris.getServer().get("service1")
        a?.method1()
    }

}


protocol Service1 {
    func method1()
}

protocol Service2 {
    func method2()
}


class Service1Impl: Service1, IServiceComponent {
    required init() {
    }
    static func config(_ profile: ServiceProfile<Service1>) {
        profile
            .setAwake { (r, s) in
                (s as! Service1Impl).service2 = r.get()
            }
            .setName("service1")
    }

    typealias Interface = Service1

    var service2: Service2?

    func method1() {
        print("method1 execute")
        service2?.method2()
    }
}

class Service2Impl: Service2, IServiceComponent {
    required init() {
    }
    static func config(_ profile: ServiceProfile<Service2>) {
    }
    func method2() {
        print("method2 execute")
    }
    typealias Interface = Service2


}



