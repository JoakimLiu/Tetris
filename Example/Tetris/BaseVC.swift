//
//  BaseVC.swift
//  Tetris_Example
//
//  Created by 王俊仁 on 2018/4/29.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

import UIKit
import Tetris

class BaseVC : UIViewController, Intentable {

    var sourceIntent: Intent? {
        didSet {
            print(sourceIntent as Any)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.lightGray
        navigationItem.title = NSStringFromClass(type(of: self))
    }

    func alert(msg: String) {
        let alert = UIAlertController.init(title: nil, message: msg, preferredStyle: .alert)

        alert.addAction(UIAlertAction.init(title: "confirm", style: .default, handler: nil))

        present(alert, animated: true, completion: nil)
    }
}
