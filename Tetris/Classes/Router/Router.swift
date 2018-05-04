//
//  Router.swift
//  Pods-Tetris_Example
//
//  Created by 王俊仁 on 2018/4/28.
//

import Foundation

public protocol URLPresentable {
    func toURL() throws -> URL
}

extension String : URLPresentable {
    public func toURL() throws -> URL {
        if let url = URL.init(string: self) {
            return url
        }
        throw TetrisError.error(domain: "url convert fail", code: 2000, info: nil)
    }
}

extension URL : URLPresentable {
    public func toURL() throws -> URL {
        return self
    }
}


public class Router {

    var viewTree = Tree()

    var actionTree = Tree()

    var broadTree = Tree()

    public init() {}

    public static let `default` = Router()

    public let intercepterMgr = IntercepterManager()

}


// MARK: - View Registery

public protocol URLRoutable {
    static var routableURL: URLPresentable {get}
}

// MARK: - View Action

public extension Router {

    public func register(_ url: URLPresentable, type: Intentable.Type) throws {

        guard let result = try URLResult.init(url: url.toURL()) else {
            return
        }
        viewTree.buildTree(nodePath: NodePath.init(path: result.paths, value: type))
    }

    public func start(_ intent: Intent, source: UIViewController? = nil, completion: IDisplayer.Completion? = nil, finish: @escaping (RouteResult) -> Void) {
        _start(intent, source: source, switched: false, completion: completion, finish: finish)
    }

    public func _start(_ intent: Intent,
                       source: UIViewController?,
                       switched: Bool,
                       completion: IDisplayer.Completion?,
                       finish: @escaping (RouteResult) -> Void) {
        build(intent: intent)
        intercepterMgr.run(intent, source: source) { (result) in
            switch result.status {
            case .switched:
                self._start(result.intent, source: source, switched: true, completion: completion, finish: finish)
            case .rejected:
                finish(RouteResult.init(status: .rejected, intent: result.intent, destination: nil, errorInfo: result.errorInfo))
            case .passed:
                if let target = intent.target {

                    var destination = target.init()

                    destination.sourceIntent = intent

                    // start transioning
                    if let source = source, let displayer = intent.displayer {

                        self.transitioning(destination, source: source, displayer: displayer, completion: completion)
                    }
                    finish(RouteResult.init(status: switched ? .switched : .passed, intent: intent, destination: destination as? UIViewController))
                } else {
                    // on lost
                    finish(RouteResult.init(status: .lost, intent: intent))
                }
            }
        }
    }

    func build(intent: Intent) {
        if let url = intent.url, intent.target == nil {
            let result = URLResult.init(url: url)
            if let result = result, let findResult = viewTree.findNode(by: result.paths) {
                intent.add(findResult.0)
                intent.add(result.params)
                intent.scheme = result.scheme
                intent.host = result.host
                intent.port = result.port
                intent.path = result.path
                intent.fragment = result.fragment
                intent.query = result.query
                intent.target = findResult.1.getValue()
            }
        }
    }

    func transitioning(_ intentable: Intentable,
                       source: UIViewController,
                       displayer: IDisplayer,
                       completion: IDisplayer.Completion?) -> Void {

        guard let target = intentable as? UIViewController else {
            return
        }
        displayer.display(from: source, to: target, animated: true, complete: completion)
    }

}


// MARK: - RouteResult
public class RouteResult {
    public enum Status: Int {
        case passed
        case switched
        case rejected
        case lost
    }

    public var destination: UIViewController?
    public var intent: Intent
    public var errorInfo: [String: Any]?
    public var status: Status

    public init(status: Status, intent: Intent, destination: UIViewController? = nil, errorInfo: [String: Any]? = nil) {
        self.destination = destination
        self.status = status
        self.intent = intent
        self.errorInfo = errorInfo
    }
}

// MARK: - Actions

public extension Router {

    public typealias RouterAction<T> = ([String: Any], String?, Packager<T>) -> Void

    public func register<Result>(_ url: URLPresentable, action: @escaping RouterAction<Result>) throws {
        if let result = try URLResult.init(url: url.toURL()) {
            let path = NodePath.init(path: result.paths, value: action)
            actionTree.buildTree(nodePath: path)
        }
    }

    public func action<Result>(_ url: URLPresentable, params: [String : Any] = [:]) throws -> Delivery<Result> {

        let result = try URLResult.init(url: url.toURL())

        if let result = result,
            let nodeRet = actionTree.findNode(by: result.paths),
            let action: RouterAction<Result> = nodeRet.1.getValue() {

            var parameters = params

            result.params.forEach { (key, value) in
                parameters[key] = value
            }

            return Delivery.init({ (p) in
                action(parameters, result.fragment, p)
                return nil
            })

        } else {
            return Delivery.error(TetrisError.error(domain: "can not find action!!!", code: 1000, info: nil))
        }
    }
}

// MARK: - Broadcast

extension Router {

    public func register(_ url: URLPresentable, broadcast: Broadcast<[String: Any]>) throws {
        if let result = try URLResult.init(url: url.toURL()) {
            let path = NodePath.init(path: result.paths, value: broadcast)
            broadTree.buildTree(nodePath: path)
        }
    }

    public func broadcast(_ url: URLPresentable) throws -> Broadcast<[String: Any]>? {
        if let result = try URLResult.init(url: url.toURL()),
            let findResult = broadTree.findNode(by: result.paths),
            let broadcast: Broadcast<[String: Any]> = findResult.1.getValue() {
            return broadcast
        }
        return nil
    }
}

// MARK: - URLResult

public struct URLResult {

    public var value: Any?

    public var params: [String:String] = [String:String]()

    public private(set) var url: URL

    public private(set) var scheme: String?

    public private(set) var host: String?

    public private(set) var port: Int?

    public private(set) var path: String?

    public private(set) var query: String?

    public private(set) var paths: [String] = [String]()

    public private(set) var fragment: String?

    public init?(url: URL) {
        self.url = url

        guard let com = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            return nil
        }

        let paths = com.path.components(separatedBy: "/").filter({$0.count > 0})

        scheme = com.scheme
        host = com.host
        path = com.path
        query = com.query
        port = com.port

        var params = [String:String]()

        com.queryItems?.forEach({ (item) in
            params[item.name] = item.value
        })

        self.params = params
        self.fragment = com.fragment
        self.paths = paths

    }

}
