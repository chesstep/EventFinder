//
//  AuthenticatorProtocol.swift
//  EventFinder
//
//  Created by Chesley Stephens on 6/20/19.
//  Copyright © 2019 Nibbis. All rights reserved.
//

import Foundation

typealias AuthenticationCompletion = (Result<URLRequest, Error>) -> Void

protocol AuthenticatorProtocol {
    
    func addAuthentication(requestConfiguration: RequestConfiguration, urlRequest: URLRequest, completion: @escaping AuthenticationCompletion)
}
