//
//  AbstractModule.swift
//  Tetris
//
//  Created by 王俊仁 on 2018/5/3.
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
