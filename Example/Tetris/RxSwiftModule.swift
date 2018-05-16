//
//  RxSwiftModule.swift
//  Tetris_Example
//
//  Created by J on 2018/5/16.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

import RxSwift
import Tetris

final class RxModule : LowPriorityModule, IModuleComponent {
    
    
    override func modulerInit(_ context: Context) {
        
    }
    
    override func modulerSetup(_ context: Context) {

        let o = Observable<Int>.create { (o) -> Disposable in
            o.onNext(1)
            return CompositeDisposable.init()
        }.do(onNext: {
            print("on next 1: \($0)")
        }).do(onNext: {
            print("on next 2: \($0)")
        }).do(onNext: {
            print("on next 3: \($0)")
        }).flatMap { (_) -> Observable<Int> in
            return Observable<Int>.error(TetrisError.error(domain: "", code: 0, info: nil))
        }
        
        let _ =
        o
        .retry(3)
        .subscribe(onNext: {
            print("\($0 as Any)")
        }, onError: {
            print("\($0 as Any)")
        })
        
        
    }
    
}
