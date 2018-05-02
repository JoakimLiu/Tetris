//
//  Router.swift
//  Pods-Tetris_Example
//
//  Created by 王俊仁 on 2018/4/28.
//

import Foundation


public class Router {

    var viewTree = Tree()

    public init() {}

    var intercepterMgr = IntercepterManager()

}


// MARK: - View Registery

public protocol URLRoutable {
    static var routableURL: String {get}
}


public protocol URLRoutableComposable : URLRoutable, Composable {}

// MARK: - View Action

public extension Router {

    public func register(_ type: Intentable.Type, for url: URL) {
        guard let result = URLResult.init(url: url) else {
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
    public enum RouteResultStatus: Int {
        case passed
        case switched
        case rejected
        case lost
    }

    public var destination: UIViewController?
    public var intent: Intent
    public var errorInfo: [String: Any]?
    public var status: RouteResultStatus

    public init(status: RouteResultStatus, intent: Intent, destination: UIViewController? = nil, errorInfo: [String: Any]? = nil) {
        self.destination = destination
        self.status = status
        self.intent = intent
        self.errorInfo = errorInfo
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
