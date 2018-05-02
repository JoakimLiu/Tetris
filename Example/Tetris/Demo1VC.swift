//
//  Demo1VC.swift
//  Tetris_Example
//
//  Created by 王俊仁 on 2018/4/29.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

import UIKit
import Tetris

class Demo1VC: BaseVC, URLRoutableComponent {

    class var routableURL: String {return "/demo/1"}


    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Demo1"
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
