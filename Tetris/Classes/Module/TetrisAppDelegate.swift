//
//  TetrisAppDelegate.swift
//  Tetris
//
//  Created by 王俊仁 on 2018/5/3.
//

import Foundation


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



