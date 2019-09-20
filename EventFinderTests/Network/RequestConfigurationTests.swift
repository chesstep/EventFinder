//
//  RequestConfigurationTests.swift
//  EventFinderTests
//
//  Created by Chesley Stephens on 6/26/19.
//  Copyright © 2019 Nibbis. All rights reserved.
//

import XCTest
@testable import EventFinder

class RequestConfigurationTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testGeneratePostRequest() {
        let expectation = self.expectation(description: #function)
        
        let requestConfiguration = RequestConfiguration(endpoint: "fake.url.com", httpMethod: .post, authenticator: nil, parameters: ["Hello": "Bolo"])
        requestConfiguration.generateRequest { (result) in
            switch result {
            case .success(let request):
                XCTAssertEqual(request.httpMethod, "POST")
            case .failure(let error):
                XCTFail("Generate request failure: \(error.localizedDescription)")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0, handler: nil)
    }
}
