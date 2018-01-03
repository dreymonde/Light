//
//  WebAPIProtocol.swift
//  Light
//
//  Created by Олег on 03.01.2018.
//

import Foundation
import Shallows

public protocol WebAPIProtocol {
    
    init(webAPI: WebAPI)
    
}

extension WebAPI : WebAPIProtocol {
    
    public init(webAPI: WebAPI) {
        self = webAPI
    }
    
}

