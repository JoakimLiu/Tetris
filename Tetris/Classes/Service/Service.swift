//
//  ServiceProfile.swift
//  Tetris
//
//  Created by 王俊仁 on 2018/5/3.
//

import Foundation

// MARK: - IService

public protocol IService {
    associatedtype Interface
    static func profile() -> ServiceProfile<Interface>
    static func config(_ profile: ServiceProfile<Interface>)
}

public extension IService where Self : Initializable {
    static func profile() -> ServiceProfile<Interface> {
        return ServiceProfile.init(Interface.self, impl: Self.self)
    }
}


// MARK: - ServiceProfile

public protocol IServiceProfile {
    var name: String? {get}
    var implementation: Initializable.Type {get}
    var interface: Any.Type {get}
    var singleton: Bool {get}
    var didAwake: Any? {get}

    func getService() -> Any

}

public class ServiceProfile<Interface> : IServiceProfile {

    public func getService() -> Any {
        if singleton {
            return singletonInstance
        } else {
            return generate()
        }
    }
    public var implementation: Initializable.Type {return implType}
    public var interface: Any.Type {return interfaceType}
    public var didAwake: Any? {return awake}
    public var name: String? = nil
    public var singleton: Bool = false

    // MARK: impl properties
    lazy public var singletonInstance: Any = generate()
    var implType: Initializable.Type!
    var interfaceType: Interface.Type!
    var awake: (Server, Interface) -> Void = {_, _ in}

    weak var servicer: Server?

    public init(_ interface: Interface.Type, impl: Initializable.Type) {
        self.implType = impl
        self.interfaceType = interface
    }

    // MARK: methods
    public func generate() -> Any {
        let impl = implType.init()
        if let servicer = servicer {
            awake(servicer, impl as! Interface)
        }
        return impl
    }

    @discardableResult
    public func setAwake(_ awake: @escaping (Server, Interface) -> Void) -> Self {
        self.awake = awake
        return self
    }

    @discardableResult
    public func setName(_ name: String) -> Self {
        self.name = name
        return self
    }

    @discardableResult
    public func setSingle() -> Self {
        self.singleton = true
        return self
    }


}
