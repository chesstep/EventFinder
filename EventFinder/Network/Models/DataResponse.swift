//
//  DataResponse.swift
//  EventFinder
//
//  Created by Chesley Stephens on 6/20/19.
//  Copyright © 2019 Nibbis. All rights reserved.
//

import Foundation

struct DataResponse<T> {
    
    let data: T?
    let urlResponse: URLResponse?
    
    init(data: T?, urlResponse: URLResponse?) {
        self.data = data
        self.urlResponse = urlResponse
    }
}
