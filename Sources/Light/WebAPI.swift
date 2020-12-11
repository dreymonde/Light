//
//  WebStorage.swift
//  LightTests
//
//  Created by Олег on 02.01.2018.
//

import Foundation
import Shallows

public struct WebAPI : ReadOnlyStorageProtocol {
    
    public enum Request {
        case url(URL)
        case urlRequest(URLRequest)
    }
    
    public struct Response {
        public var httpUrlResponse: HTTPURLResponse
        public var data: Data
    }
    
    public var storageName: String {
        return underlying.storageName + "_webapi"
    }
    
    private let underlying: ReadOnlyStorage<Request, Response>
    public let dataOnly: ReadOnlyStorage<Request, Data>
    
    public init(provider: ReadOnlyStorage<Request, Response>) {
        self.underlying = provider
        self.dataOnly = provider
            .mapValues { $0.data }
    }
    
    public func retrieve(forKey request: Request, completion: @escaping (ShallowsResult<Response>) -> ()) {
        underlying.retrieve(forKey: request, completion: completion)
    }
}

extension ReadOnlyStorageProtocol where Key == WebAPI.Request {
    
    public func retrieve(forKey url: URL, completion: @escaping (ShallowsResult<Value>) -> ()) {
        retrieve(forKey: .url(url), completion: completion)
    }
    
    public func retrieve(forKey url: URLRequest, completion: @escaping (ShallowsResult<Value>) -> ()) {
        retrieve(forKey: .urlRequest(url), completion: completion)
    }
    
}
