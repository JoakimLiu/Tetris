//
//  TetrisInitializableTests.swift
//  Tetris_Tests
//
//  Created by 王俊仁 on 2018/4/28.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

import XCTest
@testable import Tetris

class RandomClass: Awakable {
    static func tetrisAwake() {
        print("\(self) tetrisInit")
    }
}

class TetrisInitializableTests: XCTestCase, Awakable {

    static func tetrisAwake() {
        print("\(self) tetrisInit")
    }
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        Tetris.start()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    

}
