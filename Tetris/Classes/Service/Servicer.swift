//
//  Servicer.swift
//  Tetris
//
//  Created by 王俊仁 on 2018/5/2.
//

import Foundation


public protocol ServiceAwakable {
    func awake(from servicer: Servicer)
}

public extension ServiceAwakable {
    func awake(from servicer: Servicer) {

    }
}


public protocol Servicable: ServiceAwakable {

    init()
    static var type: Any.Type? { get }
    static var name: String? { get }
    static var singleton: Bool { get }

}

public extension Servicable {
    static var name: String? {return nil}
    static var type: Any.Type? {return nil}
    static var singleton: Bool { return false }

    static func validatingServicable() -> Bool {
        return !(name == nil && type == nil)
    }

}

public protocol ServiceComposable : Servicable, Composable {}

public class Servicer {

    public init() {}
    public static let `default` = Servicer()

    var oriService = [String : ServiceWrapper]()
    var nameService = [String : ServiceWrapper]()

    private func getName(with type: Any.Type) -> String {
        return "\(type.self)"
    }

    public func register(_ type: Servicable.Type) {

        assert(type.validatingServicable(), "should return a name or a type")

        let serviceWrapper = ServiceWrapper.init(type, self)

        if let serviceType = type.type {
            oriService[getName(with: serviceType)] = serviceWrapper
        }

        if let name = type.name {
            nameService[name] = serviceWrapper
        }
    }

    public func get<Service>(_ name: String? = nil) -> Service? {
        if let name = name {
            return nameService[name]?.getService() as? Service

        } else if let wrapper = oriService[getName(with: Service.self)] {
            return wrapper.getService() as? Service

        }
        return nil
    }

}


class ServiceWrapper {

    private var type: Servicable.Type
    weak private var servicer: Servicer?


    private lazy var singleton = generateService()

    init(_ type: Servicable.Type, _ servicer: Servicer) {
        self.type = type
        self.servicer = servicer
    }

    func getService() -> Servicable {
        if type.singleton {
            return singleton
        } else {
            return generateService()
        }
    }

    private func generateService() -> Servicable {
        let s = type.init()
        if let ser = servicer {
            s.awake(from: ser)
        }
        return s
    }

}

