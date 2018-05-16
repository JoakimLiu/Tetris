//
//  TestPixelDemoVC.swift
//  Tetris_Example
//
//  Created by J on 2018/5/11.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

import UIKit
import Tetris

@objc
public protocol StaticMethodProtocol {
    static func method()
}

class TestPixelDemoVC: BaseVC, IRouterComponent {
    
    static var routableURL: URLPresentable {return "/demo/pixcel"}
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        print("scale: \(UIScreen.main.scale.description)")
    
        ts._send(result: "Pixcel demo finished")
        
        for idx in 0..<5 {
            let line = getLine(height: getWidth(pixcel: 1))
            line.frame.origin.x = 0
            line.frame.origin.y = 100 + (CGFloat(idx) * 10)
            view.addSubview(line)
        }
        
        for idx in 0..<5 {
            let line = getLine(height: getWidth(pixcel: 2))
            line.frame.origin.x = 0
            line.frame.origin.y = 150 + (CGFloat(idx) * 10)
            view.addSubview(line)
        }
        
        for idx in 0..<5 {
            let line = getLine(height: getWidth(pixcel: Double(idx)))
            line.frame.origin.x = 0
            line.frame.origin.y = 300 + (CGFloat(idx) * 10)
            view.addSubview(line)
        }
        

    }
    
    func getWidth(pixcel: Double) -> CGFloat {
        return (1.0 / UIScreen.main.scale) * CGFloat(pixcel)
    }
    
    func getLine(height: CGFloat) -> UIView {
        let v = UIView.init(frame: CGRect.init(x: 0, y: 0, width: view.frame.size.width, height: height))
        v.backgroundColor = UIColor.black
        return v
    }


}
