//
//  DeliveryTest.swift
//  Tetris_Example
//
//  Created by 王俊仁 on 2018/5/4.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

import Tetris

class Action1: IActionComponent {
    required init() {
    }
    var actionURL: URLPresentable = "/action/1"
    typealias Result = Int
    func routerAction(params: [String : Any], fragment: String?) -> Delivery<Int> {
        return Delivery.package(177)
    }
}

class Action2: IActionComponent {
    required init() {
    }
    var actionURL: URLPresentable = "/action/2"
    typealias Result = String
    func routerAction(params: [String : Any], fragment: String?) -> Delivery<String> {
        return Delivery.package("lkjsdflkj")
    }
}

class DeliveryModule: LowPriorityModule, IModuleComponent {

    override var priority: Prioritable {return ModulePriority.low.priority - 100}

    var delivery = Delivery.package(200)

    var broadcast = Broadcast<Int>()


    override func modulerInit(_ context: Context) {

        Delivery<String>
            .init { (p) in
                DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + 2, execute: {
                    p.package("100", error: nil)
                })
                return Order.init({

                })
            }
            .receive { (ret, err) in
                print("\(String(describing: ret)) \(String(describing: err))")
            }

        Delivery
            .package("1")
            .onNext {_,_ in print("on next")}
            .forceMap(2)
            .transform { _ in Delivery<Int>.error(TetrisError.error(domain: "nil", code: 1, info: nil))}
            .catch { (err) in
                return Delivery.package("100")
            }
            .onSuccess { print($0 as Any) }
            .receive { (ret, err) in
                print("\(String(describing: ret)) \(String(describing: err))")
            }


        delivery
            .async()
            .receive { (_, _) in
            print("1")
        }

        delivery.receive { (_, _) in
            print("2")
        }

        delivery.receive { (_, _) in
            print("3")
        }


        getRouter().action("/action/1").receive { (ret: Int?, err) in
            print(ret as Any)
        }

        getRouter().action("/action/2").receive { (ret: String?, err) in
            print(ret as Any)
        }



        broadcast.listening { print("\($0 as Any) 1") }
        broadcast.listening { print("\($0 as Any) 2") }
        broadcast.listening { print("\($0 as Any) 3") }
        broadcast.post(100)

        let mycast = Broadcast<[String : Any]>()
        getRouter().register("/cast/1", broadcast: mycast)
        getRouter().broadcast("/cast/1")?.listening({print("\($0 as Any)")})
        getRouter().broadcast("/cast/1")?.listening({print("\($0 as Any)")})
        getRouter().broadcast("/cast/1")?.listening({print("\($0 as Any)")})

        mycast.post(["1" : 1])

        

        
//        let d = Delivery<Int>.init { (p) in
//            p.package(nil, error: TetrisError.error(domain: "", code: 100, info: nil))
//            return nil
//        }
        let d =
            Delivery
                .package(1)
                .transform { (_) in
                    return Delivery<Int>.error(TetrisError.error(domain: "", code: 100, info: nil))
                }
        
        
        d
        .retry()
        .receive({
            print("\($0 as Any) \($1 as Any)")
        })

    }
}


protocol Action {
    associatedtype Base
    func action() -> Base?
}

class ActionWrapper<T> : Action {
    typealias Base = T

    var value: T?

    func action() -> T? {
        return value
    }

    init(_ value: T?) {
        self.value = value
    }
}

class Manager<Value> {

    func set<U: Action, T>(_ aa: U?) where U.Base == T {
    }

    func test() {
        self.set(ActionWrapper.init(1))
    }
}



