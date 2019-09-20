//
//  ErrorResponse.swift
//  EventFinder
//
//  Created by Chesley Stephens on 6/20/19.
//  Copyright © 2019 Nibbis. All rights reserved.
//

import Foundation

struct ErrorResponse {
    
    let data: Data?
    let urlResponse: URLResponse?
    var statusCode: Int? {
        guard let httpURLResponse = urlResponse as? HTTPURLResponse else {
            return nil
        }
        return httpURLResponse.statusCode
    }
    
    init(data: Data?, urlResponse: URLResponse?) {
        self.data = data
        self.urlResponse = urlResponse
    }
}
