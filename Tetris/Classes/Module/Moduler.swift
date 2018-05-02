//
//  Module.swift
//  Tetris
//
//  Created by 王俊仁 on 2018/4/28.
//

import Foundation

// MARK: - Priority

public typealias ModulePriority = Int
public let ModulePriority_low: ModulePriority = 1000
public let ModulePriority_normal: ModulePriority = 5000
public let ModulePriority_high: ModulePriority = 10000

public protocol Modulable {

    var priority: ModulePriority {get}

    func modulerDidTrigger(_ event: Int, userInfo: [String: Any])

    func modulerInit(_ context: Context)
    func modulerSetup(_ context: Context)
    func modulerSplash(_ context: Context)

    func modulerWillResignActive(_ context: Context)
    func modulerDidEnterBackground(_ context: Context)
    func modulerWillEnterForeground(_ context: Context)
    func modulerDidBecomeActive(_ context: Context)

    func modulerWillTerminate(_ context: Context)

    func modulerDidReceiveRemoteNotification(_ context: Context)
    func modulerDidRegisterRemoteNotification(_ context: Context)

    func modulerDidReceiveLocalNotification(_ context: Context)

    func modulerHandleOpenURL(_ context: Context)
    func modulerHandleOpenURL_SourceApplication_Annotation(_ context: Context)
    func modulerHandleOpenURL_Options(_ context: Context)
}

public protocol ModuleComposable : Composable {}



// MARK: - Context
public class Context {
    public static let shared = Context()
    private init() {}

    // MARK: application relate
    public private(set) var application = UIApplication.shared
    public private(set) var applicationDelegate = UIApplication.shared.delegate

    // MARK: launch relate
    public var launchOptions: [UIApplicationLaunchOptionsKey: Any]?

    // MARK: open url relate
    public var openURL: URL?
    public var sourceApplication: String?
    public var annotation: Any?
    public var openURLOptions: [UIApplicationOpenURLOptionsKey: Any]?

    // MARK: remote notification relate
    public var remoteNotificationItem = RemoteNotificationItem()

    // MARK: local notification relate
    public var localNotification: UILocalNotification?

}

public class RemoteNotificationItem {
    public var userInfo: [AnyHashable: Any]?
    public var failRegisterError: Error?
    public var deviceToken: Data?
}


// MARK: - Modulable
// 因为swift4的协议柯里化存在编译问题，暂时方法使用类进行定义，待 swift 修复之后再使用协议
open class AbstractModule : Modulable {
    public required init() {}
    open var priority: ModulePriority { return ModulePriority_low }

    open func modulerDidTrigger(_ event: Int, userInfo: [String: Any]) {}
    open func modulerInit(_ context: Context) {}
    open func modulerSetup(_ context: Context) {}
    open func modulerSplash(_ context: Context) {}
    open func modulerWillResignActive(_ context: Context) {}
    open func modulerDidEnterBackground(_ context: Context) {}
    open func modulerWillEnterForeground(_ context: Context) {}
    open func modulerDidBecomeActive(_ context: Context) {}
    open func modulerWillTerminate(_ context: Context) {}
    open func modulerDidReceiveRemoteNotification(_ context: Context) {}
    open func modulerDidRegisterRemoteNotification(_ context: Context) {}
    open func modulerDidReceiveLocalNotification(_ context: Context) {}
    open func modulerHandleOpenURL(_ context: Context) {}
    open func modulerHandleOpenURL_SourceApplication_Annotation(_ context: Context) {}
    open func modulerHandleOpenURL_Options(_ context: Context) {}
}

open class HighPriorityModule : AbstractModule {
    open override var priority: ModulePriority {return ModulePriority_high}
}
open class NormalPriorityModule : AbstractModule {
    open override var priority: ModulePriority {return ModulePriority_normal}
}
open class LowPriorityModule : AbstractModule {
    open override var priority: ModulePriority {return ModulePriority_low}
}


// MARK: - Moduler
public class Moduler {

    public init() {}

    public static let `default` = Moduler()

    var modules: [AbstractModule] = [AbstractModule]()

    public func register(_ module: AbstractModule) {
        let priority = module.priority
        let index = modules.index { $0.priority < priority }
        if let idx = index {
            modules.insert(module, at: idx)
        } else {
            modules.append(module)
        }
    }

    public func trigger(_ action: (AbstractModule) -> (Context) -> Void) {
        modules.enumerated().forEach { (idx, module) in
            action(module)(Context.shared)
        }
    }

    public func trigger(event: Int, userInfo: [String: Any] = [String: Any]()) {
        modules.enumerated().forEach { (idx, module) in
            module.modulerDidTrigger(event, userInfo: userInfo)
        }
    }


}

// MARK: - TetrisAppDelegate
open class TetrisAppDelegate : UIResponder, UIApplicationDelegate {
    open func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {

        Tetris.getModuler().trigger(AbstractModule.modulerInit)
        Tetris.getModuler().trigger(AbstractModule.modulerSetup)
        DispatchQueue.global().async {
            Tetris.getModuler().trigger(AbstractModule.modulerSplash)
        }
        return true
    }

    open func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        Context.shared.openURL = url
        Context.shared.openURLOptions = options
        Tetris.getModuler().trigger(AbstractModule.modulerHandleOpenURL_Options)
        return true
    }

    open func application(_ application: UIApplication, handleOpen url: URL) -> Bool {
        Context.shared.openURL = url
        Tetris.getModuler().trigger(AbstractModule.modulerHandleOpenURL)
        return true
    }

    open func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        Context.shared.openURL = url
        Context.shared.sourceApplication = sourceApplication
        Context.shared.annotation = annotation
        Tetris.getModuler().trigger(AbstractModule.modulerHandleOpenURL_SourceApplication_Annotation)
        return true
    }

    open func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        Context.shared.remoteNotificationItem.userInfo = userInfo
        Tetris.getModuler().trigger(AbstractModule.modulerDidReceiveRemoteNotification)
    }

    open func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        Context.shared.remoteNotificationItem.failRegisterError = error
        Tetris.getModuler().trigger(AbstractModule.modulerDidRegisterRemoteNotification)
    }

    open func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
        Context.shared.localNotification = notification
        Tetris.getModuler().trigger(AbstractModule.modulerDidReceiveLocalNotification)
    }

    open func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Context.shared.remoteNotificationItem.deviceToken = deviceToken
        Tetris.getModuler().trigger(AbstractModule.modulerDidRegisterRemoteNotification)
    }

}



