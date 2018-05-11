//
//  Demo1VC.swift
//  Tetris_Example
//
//  Created by 王俊仁 on 2018/4/29.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

import UIKit
import Tetris

class Demo1VC: BaseVC, IRouterComponent {


    class var routableURL: URLPresentable {return "/demo/1"}


    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Demo1"
        ts._send(result: "demo1 response")
        sourceIntent?._send(signal: "signal 1")
        sourceIntent?._send(signal: "signal 2")
        sourceIntent?._send(signal: "signal 3")
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        ts._send(result: "demo1 response 2")

    }

}
