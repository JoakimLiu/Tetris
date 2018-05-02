//
//  File.swift
//  Tetris
//
//  Created by 王俊仁 on 2018/4/28.
//

import Foundation

public protocol Intentable {
    init()
    var sourceIntent: Intent? {get set}
}

public protocol ResponseReceivable {
    func didReceive<T>(resp: T?, sender: Any, response code: Int);
}

public typealias IntentResponse<T> = (T?, Any, Int) -> Void

public class Intent {

    public var target: Intentable.Type?

    public var url: URL?

    public var responseCode: Int = 0

    public var params = [String : Any]()

    public var scheme: String?
    public var host: String?
    public var port: Int?
    public var path: String?
    public var query: String?
    public var fragment: String?

    public var displayer: IDisplayer?

    public var recevable: ResponseReceivable?

    public func add(_ param: Any, for key: String) {
        params[key] = param
    }

    public func add(_ params: [String: Any]) {
        self.params.merge(params, uniquingKeysWith: {return $1})
    }

    public func setupResp<Result>(_ resp: @escaping IntentResponse<Result>) {
        recevable = DefaultReceiver.init(resp)
    }

    public func sendResp<T>(_ resp: T?, sender: Any, response code: Int = 0) {
        recevable?.didReceive(resp: resp, sender: sender, response: code)
    }

    public static func intent(_ url: URL? = nil, target: Intentable.Type? = nil) -> Intent {
        let intent = Intent()
        intent.target = target
        intent.url = url
        return intent
    }

}


public class DefaultReceiver: ResponseReceivable {

    var response: Any?

    public init<T>(_ resp: @escaping IntentResponse<T>) {
        self.response = resp as Any
    }

    public func didReceive<T>(resp: T?, sender: Any, response code: Int) {
        (response as? IntentResponse)?(resp, sender, code)
    }
}
