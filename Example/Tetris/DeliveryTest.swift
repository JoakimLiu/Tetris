//
//  DeliveryTest.swift
//  Tetris_Example
//
//  Created by 王俊仁 on 2018/5/4.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

import Tetris

class A {
    func method(_ temp: Int)  {

    }

    func method(_ temp: String)  {

    }

    func method(_ temp: () -> Void)  {

    }
}

class DeliveryModule: LowPriorityModule, IModuleComponent {

    override var priority: ModulePriority {return ModulePriority_low - 100}

    var delivery = Delivery.package(200)

    var broadcast = Broadcast<Int>()

    override func modulerInit(_ context: Context) {

        A().method(1)
        A().method("1")
        A().method {

        }

        Delivery<String>
            .init { (p) in
                DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + 2, execute: {
                    p.package("100", error: nil)
                })
                return DeliveryOrder.init({

                })
            }
            .receive { (ret, err) in
                print("\(String(describing: ret)) \(String(describing: err))")
            }

        Delivery
            .package("1")
            .onNext {_,_ in print("on next")}
            .forceMap(2)
            .transform { _ in Delivery<Int>.error(TetrisError.error(domain: nil, code: 1, info: nil))}
            .catch({ (err) in
                return Delivery.package("100")
            })
            .onSuccess({print($0 as Any)})
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

        try? getRouter().register("/action/1") { (_, _, p: Packager<Int>) in
            p.package(1, error: nil)
        }

        let _ = try? getRouter().action("/action/1").receive { (ret: Int?, err) in
            print(ret as Any)
        }



        broadcast.listening { print("\($0 as Any) 1") }
        broadcast.listening { print("\($0 as Any) 2") }
        broadcast.listening { print("\($0 as Any) 3") }
        broadcast.post(100)

        let mycast = Broadcast<[String : Any]>()
        try? getRouter().register("/cast/1", broadcast: mycast)
        let _ = try? getRouter().broadcast("/cast/1")?.listening({print("\($0 as Any)")})
        let _ = try? getRouter().broadcast("/cast/1")?.listening({print("\($0 as Any)")})
        let _ = try? getRouter().broadcast("/cast/1")?.listening({print("\($0 as Any)")})

        mycast.post(["1" : 1])


    }
}
