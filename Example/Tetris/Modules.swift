//
//  Modules.swift
//  Tetris_Example
//
//  Created by 王俊仁 on 2018/4/28.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

import Foundation
import Tetris

class HighModule: HighPriorityModulable, ModuleComponent {

    override func modulerInit(_ context: Context) {
        print("\(self)   \(#function)")
    }
}

class NormalModule: NormalPriorityModulable, ModuleComponent {

    override func modulerInit(_ context: Context) {
        print("\(self)   \(#function)")
    }
}

class LowModule: LowPriorityModulable, ModuleComponent {

    override func modulerInit(_ context: Context) {
        print("\(self)   \(#function)")
    }

}
