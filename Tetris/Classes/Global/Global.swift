//
//  Global.swift
//  Tetris
//
//  Created by 王俊仁 on 2018/4/28.
//

import Foundation

// MARK: - Global initialization

var globalModuler: Moduler!
var globalRouter: Router!

public func initialization(_ moduler: Moduler? = Moduler(), _ router: Router? = Router()) {
    globalRouter = router
    globalModuler = moduler
    TetrisInitializer.action
}

public func getModuler() -> Moduler {
    return globalModuler
}

public func getRouter() -> Router {
    return globalRouter
}


public extension Composable where Self : Modulable {
    public static func tetrisInit() {
        getModuler().register(Self.init() as! AbstractModule)
    }
}

public extension Composable where Self : URLRoutable, Self : UIViewController, Self : Intentable {
    static func tetrisInit() {
        getRouter().register(Self.self, for: URL.init(string: self.routableURL)!)
    }
}

public extension Composable where Self : IIntercepter {
    static func tetrisInit() {
        getRouter().intercepterMgr.add(Self.init())
    }
}







// MARK: - OC bridge
