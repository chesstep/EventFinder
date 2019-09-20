//
//  EventRepositoryTests.swift
//  EventFinderTests
//
//  Created by Chesley Stephens on 9/20/19.
//  Copyright © 2019 Nibbis. All rights reserved.
//

import XCTest
@testable import EventFinder

class EventRepositoryTests: XCTestCase {
    
    var appConfiguration: AppConfiguration!
    
    var eventRepository: EventRepository!
    var localDataSource: EventLocalDataSourceMock!
    var networkDataSource: EventNetworkDataSourceMock!
    
    override func setUp() {
        let networkManagerMock = NetworkManagerMock()
        
        eventRepository = EventRepository(networkManager: networkManagerMock)
        localDataSource = EventLocalDataSourceMock()
        eventRepository.localDataSource = localDataSource
        networkDataSource = EventNetworkDataSourceMock()
        eventRepository.networkDataSource = networkDataSource
        
        appConfiguration = AppConfiguration()
        appConfiguration.networkManager = networkManagerMock
        appConfiguration.eventRepository = eventRepository
    }
    
    override func tearDown() { }
    
    func testQueryEvents_Success() {
        var events = [Event]()
        for index in 0..<20 {
            let event = Event(id: index, title: "Title \(index)", date: Date(), city: "Austin", state: "TX", imageURL: nil)
            events.append(event)
        }
        
        networkDataSource.dataSourceCompletionResult = .success(events)
        
        let expectation = self.expectation(description: #function)
        eventRepository.queryEvents(query: "texas rangers") { result in
            switch result {
            case .success(let eventsReturned):
                XCTAssertEqual(eventsReturned, events)
            case .failure:
                XCTFail("Test should have succeeded")
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testQueryEvents_Failure() {
        networkDataSource.dataSourceCompletionResult = .failure(NetworkError.authenticationFailure)
        
        let expectation = self.expectation(description: #function)
        eventRepository.queryEvents(query: "texas rangers") { result in
            switch result {
            case .success:
                XCTFail("Test should have failed")
            case .failure(let error):
                XCTAssertEqual(error.localizedDescription, NetworkError.authenticationFailure.localizedDescription)
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testAddFavoriteEvent() {
        let event = Event(id: 1, title: "Batman", date: Date(), city: "Gotham", state: "Gotham", imageURL: nil)
        eventRepository.addFavorite(event: event)
        XCTAssertTrue(eventRepository.eventIsFavorite(event: event))
    }
    
    func testRemoveFavoriteEvent() {
        let event = Event(id: 1, title: "Batman", date: Date(), city: "Gotham", state: "Gotham", imageURL: nil)
        eventRepository.addFavorite(event: event)
        XCTAssertTrue(eventRepository.eventIsFavorite(event: event))
        
        eventRepository.removeFavorite(event: event)
        XCTAssertFalse(eventRepository.eventIsFavorite(event: event))
    }
}
