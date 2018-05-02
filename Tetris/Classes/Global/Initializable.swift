//
//  TetrisInitializable.swift
//  Tetris
//
//  Created by 王俊仁 on 2018/4/28.
//

import Foundation

public protocol Initializable : class {
    static func tetrisInit()
}

public protocol Component : Initializable {
    init()
}

class TetrisInitializer {

    static let action: Void = {
        execute()
    }()

    private static func execute() {
        let typeCount = Int(objc_getClassList(nil, 0))
        let types = UnsafeMutablePointer<AnyClass>.allocate(capacity: typeCount)
        let autoreleasingTypes = AutoreleasingUnsafeMutablePointer<AnyClass>(types)
        objc_getClassList(autoreleasingTypes, Int32(typeCount))
        let begin = Date.init().timeIntervalSince1970
        for index in 0 ..< typeCount {
            (types[index] as? Initializable.Type)?.tetrisInit()
        }
        let end = Date().timeIntervalSince1970
        print("\(begin)")
        print("\(end)")
        types.deallocate()
    }
}
