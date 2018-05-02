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

public protocol IModulable {

    var priority: ModulePriority {get}

     func modulerDidTrigger(_ event: Int, userInfo: [String: Any]) -> Void

    func modulerInit(_ context: Context) -> Void
    func modulerSetup(_ context: Context) -> Void
    func modulerSplash(_ context: Context) -> Void

    func modulerWillResignActive(_ context: Context) -> Void
    func modulerDidEnterBackground(_ context: Context) -> Void
    func modulerWillEnterForeground(_ context: Context) -> Void
    func modulerDidBecomeActive(_ context: Context) -> Void

    func modulerWillTerminate(_ context: Context) -> Void

    func modulerDidReceiveRemoteNotification(_ context: Context) -> Void
    func modulerDidRegisterRemoteNotification(_ context: Context) -> Void

    func modulerDidReceiveLocalNotification(_ context: Context) -> Void

    func modulerHandleOpenURL(_ context: Context) -> Void
    func modulerHandleOpenURL_SourceApplication_Annotation(_ context: Context) -> Void
    func modulerHandleOpenURL_Options(_ context: Context) -> Void
}

public protocol ModuleComponent : Component {}



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
open class Modulable : IModulable {
    public required init() {}
    open var priority: ModulePriority { return ModulePriority_low }

    open func modulerDidTrigger(_ event: Int, userInfo: [String: Any]) -> Void {}
    open func modulerInit(_ context: Context) -> Void {}
    open func modulerSetup(_ context: Context) -> Void {}
    open func modulerSplash(_ context: Context) -> Void {}
    open func modulerWillResignActive(_ context: Context) -> Void {}
    open func modulerDidEnterBackground(_ context: Context) -> Void {}
    open func modulerWillEnterForeground(_ context: Context) -> Void {}
    open func modulerDidBecomeActive(_ context: Context) -> Void {}
    open func modulerWillTerminate(_ context: Context) -> Void {}
    open func modulerDidReceiveRemoteNotification(_ context: Context) -> Void {}
    open func modulerDidRegisterRemoteNotification(_ context: Context) -> Void {}
    open func modulerDidReceiveLocalNotification(_ context: Context) -> Void {}
    open func modulerHandleOpenURL(_ context: Context) -> Void {}
    open func modulerHandleOpenURL_SourceApplication_Annotation(_ context: Context) -> Void {}
    open func modulerHandleOpenURL_Options(_ context: Context) -> Void {}
}

open class HighPriorityModulable : Modulable {
    open override var priority: ModulePriority {return ModulePriority_high}
}
open class NormalPriorityModulable : Modulable {
    open override var priority: ModulePriority {return ModulePriority_normal}
}
open class LowPriorityModulable : Modulable {
    open override var priority: ModulePriority {return ModulePriority_low}
}


// MARK: - Moduler
public class Moduler {

    public init() {}

    var modules: [Modulable] = [Modulable]()

    public func register(_ module: Modulable) {
        let priority = module.priority
        let index = modules.index { $0.priority < priority }
        if let idx = index {
            modules.insert(module, at: idx)
        } else {
            modules.append(module)
        }
    }

    public func trigger(_ action: (Modulable) -> (Context) -> Void) {
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

        Tetris.getModuler().trigger(Modulable.modulerInit)
        Tetris.getModuler().trigger(Modulable.modulerSetup)
        DispatchQueue.global().async {
            Tetris.getModuler().trigger(Modulable.modulerSplash)
        }
        return true
    }

    open func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        Context.shared.openURL = url
        Context.shared.openURLOptions = options
        Tetris.getModuler().trigger(Modulable.modulerHandleOpenURL_Options)
        return true
    }

    open func application(_ application: UIApplication, handleOpen url: URL) -> Bool {
        Context.shared.openURL = url
        Tetris.getModuler().trigger(Modulable.modulerHandleOpenURL)
        return true
    }

    open func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        Context.shared.openURL = url
        Context.shared.sourceApplication = sourceApplication
        Context.shared.annotation = annotation
        Tetris.getModuler().trigger(Modulable.modulerHandleOpenURL_SourceApplication_Annotation)
        return true
    }

    open func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        Context.shared.remoteNotificationItem.userInfo = userInfo
        Tetris.getModuler().trigger(Modulable.modulerDidReceiveRemoteNotification)
    }

    open func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        Context.shared.remoteNotificationItem.failRegisterError = error
        Tetris.getModuler().trigger(Modulable.modulerDidRegisterRemoteNotification)
    }

    open func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
        Context.shared.localNotification = notification
        Tetris.getModuler().trigger(Modulable.modulerDidReceiveLocalNotification)
    }

    open func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Context.shared.remoteNotificationItem.deviceToken = deviceToken
        Tetris.getModuler().trigger(Modulable.modulerDidRegisterRemoteNotification)
    }

}



