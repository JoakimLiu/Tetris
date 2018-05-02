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
var globalServicer: Servicer!

public func initialization(_ moduler: Moduler? = Moduler.default,
                           _ router: Router? = Router.default,
                           _ servicer: Servicer? = Servicer.default) {
    globalRouter = router
    globalModuler = moduler
    globalServicer = servicer
    TetrisInitializer.action
}

public func getModuler() -> Moduler {
    return globalModuler
}

public func getRouter() -> Router {
    return globalRouter
}

public func getServicer() -> Servicer {
    return globalServicer
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


public extension Composable where Self : Servicable {
    static func tetrisInit() {
        getServicer().register(Self.self)
    }
}







// MARK: - OC bridge
