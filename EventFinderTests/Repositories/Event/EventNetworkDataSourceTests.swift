//
//  EventNetworkDataSourceTests.swift
//  EventFinderTests
//
//  Created by Chesley Stephens on 9/20/19.
//  Copyright © 2019 Nibbis. All rights reserved.
//

import XCTest
@testable import EventFinder

class EventNetworkDataSourceTests: XCTestCase {
    
    var appConfiguration: AppConfiguration!
    
    var networkManagerMock: NetworkManagerMock!
    var eventNetworkDataSource: EventNetworkDataSource!
    
    override func setUp() {
        networkManagerMock = NetworkManagerMock()
        
        eventNetworkDataSource = EventNetworkDataSource(networkManager: networkManagerMock)
    }
    
    override func tearDown() { }
    
    func testQueryEvents_Success() {
        var events = [EventNetworkModel.Event]()
        for index in 0..<20 {
            let performer = EventNetworkModel.Event.Performer(image: "test.image.url/test\(index).png")
            let venue = EventNetworkModel.Event.Venue(city: "Austin", state: "TX")
            let event = EventNetworkModel.Event(id: index, title: "Title \(index)", dateTimeLocal: "2012-03-09T19:00:00", performers: [performer], venue: venue)
            events.append(event)
        }
        let eventNetworkModel: Decodable = EventNetworkModel(events: events)
        let dataResponse = DataResponse(data: eventNetworkModel, urlResponse: nil)
        
        networkManagerMock.modelRequestCompletionResult = .success(dataResponse)
        
        let expectation = self.expectation(description: #function)
        eventNetworkDataSource.queryEvents(query: "texas rangers") { result in
            switch result {
            case .success(let returnedEvents):
                XCTAssertEqual(returnedEvents.count , events.count)
            case .failure:
                XCTFail("Test should have succeeded")
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testQueryEvents_Failure() {
        networkManagerMock.modelRequestCompletionResult = .failure(NetworkError.authenticationFailure)
        
        let expectation = self.expectation(description: #function)
        eventNetworkDataSource.queryEvents(query: "texas rangers") { result in
            switch result {
            case .success:
                XCTFail("Test should have failed")
            case .failure(let error):
                XCTAssertEqual(error.localizedDescription , NetworkError.authenticationFailure.localizedDescription)
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 10, handler: nil)
    }
}
