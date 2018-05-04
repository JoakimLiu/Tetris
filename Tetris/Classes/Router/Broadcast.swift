//
//  Broadcast.swift
//  Tetris
//
//  Created by 王俊仁 on 2018/5/4.
//

import Foundation

public protocol IListener {

    associatedtype Voice

    func onReceive(_ wave: Voice?)
}

class ListenerWrapper<T> : IListener, Equatable {

    static func == (lhs: ListenerWrapper<T>, rhs: ListenerWrapper<T>) -> Bool {
        return lhs === rhs
    }

    typealias Voice = T

    var magic: ((T?) -> Void)?

    func onReceive(_ wave: T?) {
        magic?(wave)
    }

    init(_ block: @escaping (T?) -> Void) {
        self.magic = block
    }

}

public class Remover<T> {
    var wrapper: ListenerWrapper<T>
    var broadcast: Broadcast<T>
    init(wrapper: ListenerWrapper<T>, broadcast: Broadcast<T>) {
        self.wrapper = wrapper
        self.broadcast = broadcast
    }

    public func remove() {
        if let index = broadcast.listeners.index(where: {$0 == wrapper}) {
            broadcast.listeners.remove(at: index)
        }
    }
}


public class Broadcast<Wave> {

    var listeners: [ListenerWrapper<Wave>] = [ListenerWrapper<Wave>]()

    public init () {}

    public func post(_ wave: Wave?) {
        listeners.forEach { (w) in
            w.onReceive(wave)
        }
    }

    @discardableResult
    public func listening(_ block: @escaping (Wave?) -> Void) -> Remover<Wave> {
        let wrapper = ListenerWrapper.init(block)
        listeners.append(wrapper)
        return Remover.init(wrapper: wrapper, broadcast: self)
    }

    public func removeListeners() {
        listeners = [ListenerWrapper<Wave>]()
    }


}

public extension Delivery {

    
    public func whenFirst(broadcast: Broadcast<T>, wave: T?) -> Delivery<T> {
        return first {
            broadcast.post(wave)
        }
    }

    public func whenLast(broadcast: Broadcast<T>, wave: T?) -> Delivery<T> {
        return last {
            broadcast.post(wave)
        }
    }

    public func whenNext(broadcast: Broadcast<T>, wave: T?) -> Delivery<T> {
        return onNext({ (_, _) in
            broadcast.post(wave)
        })
    }

    public func whenSuccess(broadcast: Broadcast<T>) -> Delivery<T> {
        return onSuccess { broadcast.post($0) }
    }

    public func whenError(broadcast: Broadcast<Error>) -> Delivery<T> {
        return onError { broadcast.post($0) }
    }

}





