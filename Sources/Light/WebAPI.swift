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
    
    private let underlying: ReadOnlyStorage<APIPath, Data>
    
    public init(provider: ReadOnlyStorage<APIPath, Data>) {
        self.underlying = provider
    }
    
    public init(baseURL: URL,
                networkProvider: ReadOnlyStorage<URLRequest, Data>,
                modifyRequest: @escaping (inout URLRequest) -> Void) {
        self.underlying = networkProvider
            .mapKeys(to: APIPath.self, { path in
                var request = URLRequest(url: baseURL.appendingPath(path))
                modifyRequest(&request)
                print(request.url!)
                return request
            })
    }
    
    public func retrieve(forKey path: APIPath, completion: @escaping (Result<Data>) -> ()) {
        underlying.retrieve(forKey: path, completion: completion)
    }
    
}
