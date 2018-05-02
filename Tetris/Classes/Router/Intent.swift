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
    func didReceive<T>(resp: T?, sender: Any, response respCode: Int, request reqCode: Int);
}

public typealias IntentResponse<T> = (T?, Any, Int, Int) -> Void

public class Intent {

    public var target: Intentable.Type?

    public var url: URL?

    public var responseCode: Int = 0
    public var requestCode: Int = 0

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

    public func sendResp<T>(_ resp: T?, sender: Any, response respCode: Int = 0) {
        recevable?.didReceive(resp: resp, sender: sender, response: respCode, request: requestCode)
    }

    public init() {

    }

    deinit {

    }

    public init(url: URL? = nil, target: Intentable.Type? = nil) {
        self.target = target
        self.url = url
    }

}


public class DefaultReceiver: ResponseReceivable {

    var response: Any?

    public init<T>(_ resp: @escaping IntentResponse<T>) {
        self.response = resp as Any
    }

    public func didReceive<T>(resp: T?, sender: Any, response respCode: Int, request reqCode: Int) {
        (response as? IntentResponse)?(resp, sender, respCode, reqCode)
    }
}
