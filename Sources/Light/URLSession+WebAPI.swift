//
//  URLSession+WebAPI.swift
//  Light
//
//  Created by Олег on 03.01.2018.
//

import Foundation
import Shallows

extension URLSession : ReadOnlyStorageProtocol {
    
    public typealias Request = WebAPI.Request
    public typealias Response = WebAPI.Response
    
    public enum LightError : Error {
        case taskError(Error)
        case responseIsNotHTTP(URLResponse?)
        case noData
    }
    
    public func retrieve(forKey request: Request, completion: @escaping (ShallowsResult<Response>) -> ()) {
        let completionHandler: (Data?, URLResponse?, Error?) -> () = { (data, response, error) in
            if let error = error {
                completion(fail(with: LightError.taskError(error)))
                return
            }
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(fail(with: LightError.responseIsNotHTTP(response)))
                return
            }
            guard let data = data else {
                completion(fail(with: LightError.noData))
                return
            }
            completion(succeed(with: .init(httpUrlResponse: httpResponse, data: data)))
        }
        let task: URLSessionTask
        switch request {
        case .url(let url):
            task = self.dataTask(with: url, completionHandler: completionHandler)
        case .urlRequest(let request):
            task = self.dataTask(with: request, completionHandler: completionHandler)
        }
        task.resume()
    }
}

extension ReadOnlyStorageProtocol where Key == WebAPI.Request {
    
    public func mapURLKeys() -> ReadOnlyStorage<URL, Value> {
        return mapKeys({ .url($0) })
    }
    
    public func mapURLRequestKeys() -> ReadOnlyStorage<URLRequest, Value> {
        return mapKeys({ .urlRequest($0) })
    }
    
}

extension ReadOnlyStorageProtocol where Key == URL {
    
    public func mapStringKeys() -> ReadOnlyStorage<String, Value> {
        return mapKeys({ try URL(string: $0).unwrap() })
    }
    
}

extension ReadOnlyStorageProtocol where Value == WebAPI.Response {
    
    public func droppingResponse() -> ReadOnlyStorage<Key, Data> {
        return mapValues({ $0.data })
    }
    
}

extension WebAPIProtocol {
    
    public init(urlSession: URLSession) {
        let webAPI = WebAPI(provider: urlSession.asReadOnlyStorage())
        self.init(webAPI: webAPI)
    }
    
    public init(urlSessionConfiguration: URLSessionConfiguration) {
        let urlSession = URLSession(configuration: urlSessionConfiguration)
        self.init(urlSession: urlSession)
    }
    
}
