//
//  URLSessionMock.swift
//  EventFinderTests
//
//  Created by Chesley Stephens on 6/26/19.
//  Copyright © 2019 Nibbis. All rights reserved.
//

import Foundation
@testable import EventFinder

class URLSessionMock: URLSession {
    
    override func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        let dataTaskMock = DataTaskMock()
        dataTaskMock.completionHandler = completionHandler
        return dataTaskMock
    }
}
