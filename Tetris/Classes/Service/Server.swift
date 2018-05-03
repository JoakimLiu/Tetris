//
//  Servicer.swift
//  Tetris
//
//  Created by 王俊仁 on 2018/5/2.
//

import Foundation



public class Server {

    public init() {}
    public static let `default` = Server()

    var oriService = [String : IServiceProfile]()
    var nameService = [String : IServiceProfile]()

    private func getName(with type: Any.Type) -> String {
        return "\(type.self)"
    }

    public func register(_ profile: IServiceProfile) {
        
        if let name = profile.name {
            nameService[name] = profile
        } else {
            oriService[getName(with: profile.interface)] = profile
        }
    }

    public func get<Service>(_ name: String? = nil) -> Service? {
        if let name = name {
            let profile = nameService[name]
            return profile?.getService() as? Service
        } else {
            let profile = oriService[getName(with: Service.self)]
            return profile?.getService() as? Service
        }
    }

}

