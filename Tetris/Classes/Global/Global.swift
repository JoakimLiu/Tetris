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
var globalServer: Server!

public func start(moduler: Moduler? = Moduler.default,
                  router: Router? = Router.default,
                  server: Server? = Server.default) {
    globalRouter = router
    globalModuler = moduler
    globalServer = server
    TetrisAwaker.action
}

public func getModuler() -> Moduler {
    return globalModuler
}

public func getRouter() -> Router {
    return globalRouter
}

public func getServer() -> Server {
    return globalServer
}


public typealias IModuleComponent = (IComponent)
public extension IComponent where Self : AbstractModule {
    public static func tetrisAwake() {
        getModuler().register(Self.init())
    }
}

public typealias IRouterComponent = (URLRoutable & IComponent)
public extension IComponent where Self : URLRoutable, Self : UIViewController, Self : Intentable {
    static func tetrisAwake() {
        try! getRouter().register(self.routableURL, type: Self.self)
    }
}

public typealias IIntercepterComponent = (IIntercepter & IComponent)
public extension IComponent where Self : IIntercepter {
    static func tetrisAwake() {
        getRouter().intercepterMgr.add(Self.init())
    }
}

public typealias IServiceComponent = (IService & IComponent)
public extension IComponent where Self : IService {
    static func tetrisAwake() {
        let p = serviceProfile()
        config(p)
        let servicer = getServer()
        p.servicer = servicer
        servicer.register(p)
    }
}

public typealias IActionComponent = (IComponent & IRouterAction)
public extension IComponent where Self : IRouterAction {
    static func tetrisAwake() {
        try? getRouter().register(action: Self.init())
    }
}






// MARK: - OC bridge
