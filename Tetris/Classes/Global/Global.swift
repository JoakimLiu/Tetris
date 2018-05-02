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


public extension Component where Self : IModulable {
    public static func tetrisInit() {
        globalModuler.register(Self.init() as! Modulable)
    }
}

public extension Component where Self : URLRoutable, Self : UIViewController, Self : Intentable {
    static func tetrisInit() {
        globalRouter.register(Self.self, for: URL.init(string: self.routableURL)!)
    }
}

public extension Component where Self : IIntercepter {
    static func tetrisInit() {
        globalRouter.intercepterMgr.add(Self.init())
    }
}







// MARK: - OC bridge
