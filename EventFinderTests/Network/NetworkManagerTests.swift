//
//  NetworkManagerTests.swift
//  EventFinderTests
//
//  Created by Chesley Stephens on 6/26/19.
//  Copyright © 2019 Nibbis. All rights reserved.
//

import XCTest
@testable import EventFinder

class NetworkManagerTests: XCTestCase {
    
    var networkManager: NetworkManager!
    var networkManagerMock: NetworkManagerMock!
    
    override func setUp() {
        super.setUp()
        
        networkManager = NetworkManager()
        networkManagerMock = NetworkManagerMock()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testExecuteRequest_ModelFailure_BadURL() {
        let requestConfiguration = RequestConfiguration(endpoint: "", httpMethod: .get)
        
        let expectation = self.expectation(description: #function)
        networkManagerMock.executeRequest(requestConfiguration: requestConfiguration, responseModel: DecodableMock.self, modelRequestCompletion: { result in
            switch result {
            case .success:
                break
            case .failure:
                expectation.fulfill()
            }
        })
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testExecuteRequest_ModelFailure() {
        networkManagerMock.modelRequestCompletionResult = .failure(NetworkError.invalidURL)
        let requestConfiguration = RequestConfiguration(endpoint: "fake.url.com", httpMethod: .get)
        
        let expectation = self.expectation(description: #function)
        networkManagerMock.executeRequest(requestConfiguration: requestConfiguration, responseModel: DecodableMock.self, modelRequestCompletion: { result in
            switch result {
            case .success:
                break
            case .failure:
                expectation.fulfill()
            }
        })
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testExecuteRequest_DataFailure_BadURL() {
        let requestConfiguration = RequestConfiguration(endpoint: "", httpMethod: .get)
        
        let expectation = self.expectation(description: #function)
        networkManagerMock.executeRequest(requestConfiguration: requestConfiguration, dataRequestCompletion: { result in
            switch result {
            case .success:
                break
            case .failure:
                expectation.fulfill()
            }
        })
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testExecuteRequest_DataFailure() {
        networkManagerMock.dataRequestCompletionResult = .failure(NetworkError.invalidURL)
        let requestConfiguration = RequestConfiguration(endpoint: "fake.url.com", httpMethod: .get)
        
        let expectation = self.expectation(description: #function)
        networkManagerMock.executeRequest(requestConfiguration: requestConfiguration, dataRequestCompletion: { result in
            switch result {
            case .success:
                break
            case .failure:
                expectation.fulfill()
            }
        })
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testDataTask_Error() {
        let sessionMock = URLSessionMock()
        let networkManager = NetworkManager()
        networkManager.session = sessionMock
        
        let expectation = self.expectation(description: #function)
        
        let url = URL(string: "fake.url.com")!
        let urlRequest = URLRequest(url: url)
        let dataTask = networkManager.dataTask(request: urlRequest, responseHandler: ResponseHandler(), responseModel: DecodableMock.self, modelRequestCompletion: { result in
            switch result {
            case .success:
                break
            case .failure:
                expectation.fulfill()
            }
        }, dataRequestCompletion: nil) as! DataTaskMock
        dataTask.completionHandler?(nil, nil, NetworkError.emptyServerResponse)
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testDataTask_InvalidResponse() {
        let sessionMock = URLSessionMock()
        let networkManager = NetworkManager()
        networkManager.session = sessionMock
        
        let expectation = self.expectation(description: #function)
        
        let url = URL(string: "fake.url.com")!
        let urlRequest = URLRequest(url: url)
        let dataTask = networkManager.dataTask(request: urlRequest, responseHandler: ResponseHandler(), responseModel: DecodableMock.self, modelRequestCompletion: { result in
            switch result {
            case .success:
                break
            case .failure:
                expectation.fulfill()
            }
        }, dataRequestCompletion: nil) as! DataTaskMock
        
        let response = HTTPURLResponse(url: url, statusCode: 400, httpVersion: nil, headerFields: nil)
        let data = "fakedata".data(using: .utf8)
        dataTask.completionHandler?(data, response, nil)
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testDataTask_InvalidData() {
        let sessionMock = URLSessionMock()
        let networkManager = NetworkManager()
        networkManager.session = sessionMock
        
        let expectation = self.expectation(description: #function)
        
        let url = URL(string: "fake.url.com")!
        let urlRequest = URLRequest(url: url)
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        let dataTask = networkManager.dataTask(request: urlRequest, responseHandler: ResponseHandler(), responseModel: DecodableMock.self, modelRequestCompletion: { result in
            switch result {
            case .success(let dataResponse):
                XCTAssertTrue(dataResponse.urlResponse == response)
                XCTAssertNil(dataResponse.data)
                expectation.fulfill()
            case .failure:
                break
            }
        }, dataRequestCompletion: nil) as! DataTaskMock
        
        let data = "{ stringMock: test }".data(using: .utf8)
        dataTask.completionHandler?(data, response, nil)
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testDataTask_ValidData() {
        let sessionMock = URLSessionMock()
        let networkManager = NetworkManager()
        networkManager.session = sessionMock
        
        let expectation = self.expectation(description: #function)
        
        let url = URL(string: "fake.url.com")!
        let urlRequest = URLRequest(url: url)
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        let dataTask = networkManager.dataTask(request: urlRequest, responseHandler: ResponseHandler(), responseModel: DecodableMock.self, modelRequestCompletion: { result in
            switch result {
            case .success(let dataResponse):
                XCTAssertTrue(dataResponse.urlResponse == response)
                XCTAssertNotNil(dataResponse.data)
                expectation.fulfill()
            case .failure:
                break
            }
        }, dataRequestCompletion: nil) as! DataTaskMock
        
        let data = "{ \"stringMock\": \"test\" }".data(using: .utf8)
        dataTask.completionHandler?(data, response, nil)
        waitForExpectations(timeout: 5, handler: nil)
    }
}
