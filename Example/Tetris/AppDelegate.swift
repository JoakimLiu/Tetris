//
//  AppDelegate.swift
//  Tetris
//
//  Created by scubers on 04/28/2018.
//  Copyright (c) 2018 scubers. All rights reserved.
//

import UIKit
import Tetris


@UIApplicationMain
class AppDelegate: TetrisAppDelegate {

    var window: UIWindow?

    override func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

//        Tetris.initialization()

        Tetris.initialization(Moduler(), Router(), Server())

        let _ = super.application(application, didFinishLaunchingWithOptions: launchOptions)

        window = UIWindow.init(frame: UIScreen.main.bounds)

        Tetris.getRouter().start(Intent.pushPop(url: "/demo/menu")) { (result) in
            if result.status == .passed
                || result.status == .switched {
                self.window?.rootViewController = UINavigationController.init(rootViewController: result.destination!)
            }
        }
        window?.makeKeyAndVisible()

        return true

    }
}

