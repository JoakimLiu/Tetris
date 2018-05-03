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
var globalServicer: Server!

public func initialization(_ moduler: Moduler? = Moduler.default,
                           _ router: Router? = Router.default,
                           _ servicer: Server? = Server.default) {
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

public func getServicer() -> Server {
    return globalServicer
}


public typealias IModuleComponent = (IComponent)

public extension IComponent where Self : Modulable {
    public static func tetrisAwake() {
        getModuler().register(Self.init() as! AbstractModule)
    }
}

public typealias IRouterComponent = (URLRoutable & IComponent)

public extension IComponent where Self : URLRoutable, Self : UIViewController, Self : Intentable {
    static func tetrisAwake() {
        getRouter().register(Self.self, for: URL.init(string: self.routableURL)!)
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
        let p = profile()
        config(p)
        let servicer = getServicer()
        p.servicer = servicer
        servicer.register(p)
    }
}







// MARK: - OC bridge
