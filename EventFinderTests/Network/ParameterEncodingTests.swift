//
//  ParameterEncodingTests.swift
//  EventFinderTests
//
//  Created by Chesley Stephens on 6/26/19.
//  Copyright © 2019 Nibbis. All rights reserved.
//

import XCTest
@testable import EventFinder

class ParameterEncodingTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testFormatRequestParameters_NoParameters() {
        let url = URL(string: "fake.url.com")!
        let request = URLRequest(url: url)
        let resultRequest = ParameterEncoding.formatRequestParameters(request: request, parameters: nil)
        XCTAssertTrue(request == resultRequest)
    }
    
    func testFormatRequestParameters_GetHTTPParameters() {
        let url = URL(string: "fake.url.com")!
        let request = URLRequest(url: url)
        let parameters = ["test": "1234"]
        let resultRequest = ParameterEncoding.formatRequestParameters(request: request, parameters: parameters)
        XCTAssertEqual(resultRequest.url?.absoluteString, "\(url.absoluteString)?test=1234")
    }
    
    func testFormatRequestParameters_PostHTTPParameters() {
        let url = URL(string: "fake.url.com")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let parameters = ["test": "1234"]
        let resultRequest = ParameterEncoding.formatRequestParameters(request: request, parameters: parameters)
        XCTAssertEqual(resultRequest.httpBody, "test=1234".data(using: .utf8))
    }
    
    func testFormatRequestParameters_GetHTTPParametersSpaces() {
        let url = URL(string: "fake.url.com")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let parameters = ["test": "12 34"]
        let resultRequest = ParameterEncoding.formatRequestParameters(request: request, parameters: parameters)
        XCTAssertEqual(resultRequest.url?.absoluteString, "\(url.absoluteString)?test=12%2034")
    }
    
    func testFormatRequestParameters_GetSeatGeek() {
        let url = URL(string: "https://api.seatgeek.com/2/events")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let parameters = ["q": "texas rangers"]
        let resultRequest = ParameterEncoding.formatRequestParameters(request: request, parameters: parameters)
        XCTAssertEqual(resultRequest.url?.absoluteString, "\(url.absoluteString)?q=texas%20rangers")
    }
}
