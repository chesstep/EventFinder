//
//  NetworkManagerMock.swift
//  EventFinderTests
//
//  Created by Chesley Stephens on 6/26/19.
//  Copyright © 2019 Nibbis. All rights reserved.
//

import Foundation
@testable import EventFinder

class NetworkManagerMock: NetworkManager {
    
    var modelRequestCompletionResult: Result<DataResponse<Decodable>, Error>?
    var dataRequestCompletionResult: Result<DataResponse<Data>, Error>?
    
    override func dataTask<T: Decodable>(request: URLRequest, responseHandler: ResponseHandlerProtocol, responseModel: T.Type, modelRequestCompletion: ModelRequestCompletion?, dataRequestCompletion: DataRequestCompletion?) -> URLSessionDataTask {
        
        let dataTaskMock = DataTaskMock()
        dataTaskMock.modelRequestCompletion = modelRequestCompletion
        dataTaskMock.modelRequestCompletionResult = modelRequestCompletionResult
        dataTaskMock.dataRequestCompletion = dataRequestCompletion
        dataTaskMock.dataRequestCompletionResult = dataRequestCompletionResult
        
        return dataTaskMock
    }
}
