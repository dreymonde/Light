//
//  URLSession+WebAPI.swift
//  Light
//
//  Created by Олег on 03.01.2018.
//

import Foundation
import Shallows

extension URLSession : ReadOnlyStorageProtocol {
    
    public enum Key {
        case url(URL)
        case urlRequest(URLRequest)
    }
    
    public enum CacheError : Error {
        case taskError(Error)
        case responseIsNotHTTP(URLResponse?)
        case noData
    }
    
    public func retrieve(forKey request: Key, completion: @escaping (Result<(HTTPURLResponse, Data)>) -> ()) {
        let completion: (Data?, URLResponse?, Error?) -> () = { (data, response, error) in
            if let error = error {
                completion(.failure(CacheError.taskError(error)))
                return
            }
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(CacheError.responseIsNotHTTP(response)))
                return
            }
            guard let data = data else {
                completion(.failure(CacheError.noData))
                return
            }
            completion(.success((httpResponse, data)))
        }
        let task: URLSessionTask
        switch request {
        case .url(let url):
            task = self.dataTask(with: url, completionHandler: completion)
        case .urlRequest(let request):
            task = self.dataTask(with: request, completionHandler: completion)
        }
        task.resume()
    }
    
}

extension ReadOnlyStorageProtocol where Key == URLSession.Key {
    
    public func usingURLKeys() -> ReadOnlyStorage<URL, Value> {
        return mapKeys({ .url($0) })
    }
    
    public func usingURLRequestKeys() -> ReadOnlyStorage<URLRequest, Value> {
        return mapKeys({ .urlRequest($0) })
    }
    
}

extension ReadOnlyStorageProtocol where Value == (HTTPURLResponse, Data) {
    
    public func droppingResponse() -> ReadOnlyStorage<Key, Data> {
        return mapValues({ $0.1 })
    }
    
}

extension WebAPIProtocol {
    
    public init(urlSession: URLSession) {
        let urlSessionProvider = urlSession.asReadOnlyStorage()
            .usingURLRequestKeys()
            .droppingResponse()
        let webAPI = WebAPI(provider: urlSessionProvider)
        self.init(webAPI: webAPI)
    }
    
    public init(urlSessionConfiguration: URLSessionConfiguration) {
        let urlSession = URLSession(configuration: urlSessionConfiguration)
        self.init(urlSession: urlSession)
    }
    
}
