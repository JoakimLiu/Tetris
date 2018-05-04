//
//  DeliveryTest.swift
//  Tetris_Example
//
//  Created by 王俊仁 on 2018/5/4.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

import Tetris

struct MyErr: Error {

}

class DeliveryModule: HighPriorityModule, IModuleComponent {
    override func modulerInit(_ context: Context) {

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
            .transform { _ in Delivery<Int>.error(MyErr())}
            .catch({ (err) in
                return Delivery.package("100")
            })
            .onSuccess({print($0 as Any)})
            .receive { (ret, err) in
                print("\(String(describing: ret)) \(String(describing: err))")
            }

    }
}
