//
//  WebStorage.swift
//  LightTests
//
//  Created by Олег on 02.01.2018.
//

import Foundation
import Shallows

public struct WebAPI : ReadOnlyStorageProtocol {
    
    public var storageName: String {
        return underlying.storageName + "_webapi"
    }
    
    private let underlying: ReadOnlyStorage<URLRequest, Data>
    
    public init(provider: ReadOnlyStorage<URLRequest, Data>) {
        self.underlying = provider
    }
    
    public func retrieve(forKey request: URLRequest, completion: @escaping (Result<Data>) -> ()) {
        underlying.retrieve(forKey: request, completion: completion)
    }
    
}

extension ReadOnlyStorageProtocol where Key == URLRequest {
    
    public func baseURL(_ baseURL: URL,
                        modifyRequest: @escaping (inout URLRequest) -> () = { _ in }) -> ReadOnlyStorage<APIPath, Value> {
        return self.mapKeys(to: APIPath.self, { (path) -> URLRequest in
            var request = URLRequest(url: baseURL.appendingPath(path))
            modifyRequest(&request)
            return request
        })
    }
    
}
