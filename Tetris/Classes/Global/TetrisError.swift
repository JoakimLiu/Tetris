//
//  TetrisError.swift
//  Tetris
//
//  Created by 王俊仁 on 2018/5/4.
//

import Foundation

public enum TetrisError : Error {
    case error(domain: String?, code: Int, info: [String: Any]?)
}
