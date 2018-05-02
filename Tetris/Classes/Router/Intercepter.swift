//
//  Intercepter.swift
//  Tetris
//
//  Created by 王俊仁 on 2018/4/29.
//

import Foundation

// MARK: - IntercepterPriority
public typealias IntercepterPriority = Int
public let IntercepterPriority_low: IntercepterPriority = 1000
public let IntercepterPriority_normal: IntercepterPriority = 5000
public let IntercepterPriority_high: IntercepterPriority = 10000

// MARK: - IntercepterAdjudgement
public protocol IIntercepterJudger {
    var source: UIViewController? {get}
    func getIntent() -> Intent
    func doSwitch(_ intent: Intent)
    func doReject(_ errorInfo: [String:Any])
    func doContinue()
}


// MARK: - IIntercepter
public protocol IIntercepter {

    var priority: IntercepterPriority {get}

    func doAdjudgement(_ judger: IIntercepterJudger)
}

// MARK: - FinalIntercepter
public protocol IFinalIntercepter : class {
    static func finalAdjugement(_ judger: IIntercepterJudger)
}

// MARK: - IntercepterResult
public class IntercepterResult {
    public enum InterceterResultStatus: Int {
        case passed
        case switched
        case rejected
    }

    public var status: InterceterResultStatus = .passed

    public var intent: Intent!

    public var errorInfo: [String: Any]?

    public init(status: InterceterResultStatus, intent: Intent, errorInfo: [String: Any]?) {
        self.status = status
        self.intent = intent
        self.errorInfo = errorInfo
    }
}

// MARK: - IntercepterManager
public class IntercepterManager {

    var intercepters = [IIntercepter]()

    public func add(_ interceter: IIntercepter) {
        if let index = intercepters.index(where: {return $0.priority < interceter.priority}) {
            intercepters.insert(interceter, at: index)
        } else {
            intercepters.append(interceter)
        }
    }

    public func run(_ intent: Intent, source: UIViewController?, finish: @escaping (IntercepterResult) -> Void) {
        _run(intent, source: source, intercepters: self.intercepters, index: 0, finish: finish)
    }

    func _run(_ intent: Intent, source: UIViewController?, intercepters: [IIntercepter], index: Int, finish: @escaping (IntercepterResult) -> Void) {


        let getJudger: () -> IIntercepterJudger = {
            IntercepterJudger.init(intent: intent, source: source, continued: {
                self._run(intent, source: source, intercepters: intercepters, index: index + 1, finish: finish)
            }, switched: { next in
                finish(IntercepterResult.init(status: .switched, intent: next, errorInfo: nil))
            }) { (errorInfo) in
                finish(IntercepterResult.init(status: .rejected, intent: intent, errorInfo: errorInfo))
            }
        }

        if index == intercepters.count
            , let target = intent.target as? IFinalIntercepter.Type {
            // execute final adjugement
            target.finalAdjugement(getJudger())
        } else if index < intercepters.count {
            // execute intercepter adjugement
            intercepters[index].doAdjudgement(getJudger())
        } else {
            finish(IntercepterResult.init(status: .passed, intent: intent, errorInfo: nil))
        }

    }
}


// MARK: - IntercepterJudger

class IntercepterJudger: IIntercepterJudger {

    var continueFlag = false
    var rejectedFlag = false
    var switchedFlag = false

    func checkStart() {
        assert(!continueFlag && !rejectedFlag && !switchedFlag, "you have call [doContinue] or [doReject] or [doSwitch]: \(self)")
    }

    func getIntent() -> Intent {
        return sourceIntent
    }

    func doSwitch(_ intent: Intent) {
        checkStart()
        switchedFlag = true
        switched(intent)
    }

    func doReject(_ errorInfo: [String : Any]) {
        checkStart()
        rejectedFlag = true
        reject(errorInfo)
    }

    func doContinue() {
        checkStart()
        continueFlag = true
        continued()
    }

    deinit {
        assert(rejectedFlag || continueFlag || switchedFlag, "you should call [doSwitch] or [doReject] or [doContinue]: \(self)")
    }

    var source: UIViewController?
    var sourceIntent: Intent!


    let continued: (() -> Void)!
    let switched: ((Intent) -> Void)!
    let reject: (([String:Any]) -> Void)!

    init(intent: Intent, source: UIViewController?, continued: @escaping ()->Void, switched: @escaping (Intent)-> Void, rejected: @escaping ([String:Any])->Void) {
        self.sourceIntent = intent
        self.source = source
        self.continued = continued
        self.switched = switched
        self.reject = rejected
    }


}


