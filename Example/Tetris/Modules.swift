//
//  Modules.swift
//  Tetris_Example
//
//  Created by 王俊仁 on 2018/4/28.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

import Foundation
import Tetris

class HighModule: HighPriorityModule, ModuleComposable {

    override func modulerInit(_ context: Context) {
        print("\(self)   \(#function)")
    }
}

class NormalModule: NormalPriorityModule, ModuleComposable {

    override func modulerInit(_ context: Context) {
        print("\(self)   \(#function)")
    }
}

class LowModule: LowPriorityModule, ModuleComposable {

    override func modulerInit(_ context: Context) {
        print("\(self)   \(#function)")
        let a: Service1? = Tetris.getServicer().get()
        a?.method1()
    }

}


protocol Service1 {
    func method1()
}

protocol Service2 {
    func method2()
}


class Service1Impl: Service1, ServiceComposable {

    static var type: Any.Type? {return Service1.self}

    var service2: Service2?

    required init() { }

    func awake(from servicer: Servicer) {
        service2 = servicer.get()
    }

    static var name: String? {
        return "name"

    }

    func method1() {
        print("method1 execute")
        service2?.method2()
    }
}

class Service2Impl: Service2, ServiceComposable {
    required init() {
    }
    static var type: Any.Type? {return Service2.self}
    func method2() {
        print("method2 execute")
    }
}




protocol AAA {
    associatedtype AE
    func create() -> AE
}

//var obj: AAA?

class BBB: AAA {
    typealias AE = String
    func create() -> String {
        return ""
    }
}


class Factory {

    func get<P, T: AAA>(_ dep: P.Type) -> T? where T.AE == P {
        return nil
    }

    func aaa() {
//        let ret: AAA? = get(String.self)
//        let ret: AAA where AAA.AE == String = get()
    }

}



