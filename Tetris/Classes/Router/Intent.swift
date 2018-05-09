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

public protocol ResultReceivable {
    func didReceive<T>(resp: T?, response respCode: Int);
}

public typealias ResultBlock<T> = (T?, Int) -> Void

public class Intent {


    public var target: Intentable.Type?

    public var url: URL?

    public var responseCode: Int = 0
    public var requestCode: Int = 0

    public var params = [String : Any]()

    public internal(set) var scheme: String?
    public internal(set) var host: String?
    public internal(set) var port: Int?
    public internal(set) var path: String?
    public internal(set) var query: String?
    public internal(set) var fragment: String?

    public var displayer: IDisplayer?

    private lazy var response: Response = Response()

    public func add(_ param: Any, for key: String) {
        params[key] = param
    }

    public func add(_ params: [String: Any]) {
        self.params.merge(params, uniquingKeysWith: {$1})
    }

    public func onResult<Result>(_ resp: @escaping ResultBlock<Result>) {
        response.onResultAction(resp)
    }


    public func sendResult<T>(_ resp: T?, response respCode: Int = 0) {
        response.setupResult { (receiver) in
            receiver?.didReceive(resp: resp, response: respCode)
        }
    }

    public init() {

    }

    deinit {
        response.send()
    }

    public init(url: URL? = nil, target: Intentable.Type? = nil) {
        self.target = target
        self.url = url
    }

}



class Response: ResultReceivable {

    private var receiveAction: Any?

    private var action: ((ResultReceivable?) -> Void)?

    func setupResult(_ block: @escaping (ResultReceivable?) -> Void) {
        self.action = block
    }

    func onResultAction<T>(_ action: @escaping ResultBlock<T>) {
        receiveAction = action as Any
    }

    func didReceive<T>(resp: T?, response respCode: Int) {
        (receiveAction as? ResultBlock)?(resp, respCode)
    }

    func send() {
        action?(self)
    }
}


