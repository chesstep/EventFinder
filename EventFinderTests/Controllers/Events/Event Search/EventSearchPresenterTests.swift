//
//  EventSearchPresenter.swift
//  EventFinderTests
//
//  Created by Chesley Stephens on 9/20/19.
//  Copyright © 2019 Nibbis. All rights reserved.
//

import XCTest
@testable import EventFinder

class EventSearchViewMock: EventSearchView {
    
    var state: EventSearchViewController.State?
    var events: [Event]?
    
    var setStateCalled = false
    var setEventsCalled = false
    var presentAlertCalled = false
    
    var expectation: XCTestExpectation?
    
    func setState(state: EventSearchViewController.State) {
        self.state = state
        setStateCalled = true
    }
    
    func setEvents(events: [Event]) {
        self.events = events
        setEventsCalled = true
        fulfillExpectation()
    }
    
    func presentAlert(title: String?, message: String?) {
        presentAlertCalled = true
        fulfillExpectation()
    }
    
    func fulfillExpectation() {
        expectation?.fulfill()
        expectation = nil
    }
}

class EventSearchPresenterTests: XCTestCase {
    
    var appConfiguration: AppConfiguration!
    
    var presenter: EventSearchPresenter!
    var viewMock: EventSearchViewMock!
    
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
        
        viewMock = EventSearchViewMock()
        presenter = EventSearchPresenter(appConfiguration: appConfiguration)
        
        presenter.attachView(view: viewMock)
    }
    
    override func tearDown() {
        presenter.detachView()
    }
    
    func testQueryEvents_NilQuery() {
        let events = [Event]()
        
        networkDataSource.dataSourceCompletionResult = .failure(NetworkError.authenticationFailure)
        viewMock.expectation = expectation(description: #function)
        
        presenter.queryEvents(query: nil)
        waitForExpectations(timeout: 10, handler: nil)
        
        XCTAssertTrue(viewMock.setEventsCalled)
        XCTAssertEqual(viewMock.events, events)
        
        XCTAssertTrue(viewMock.setStateCalled)
        XCTAssertEqual(viewMock.state, EventSearchViewController.State.start)
    }
    
    func testQueryEvents_EmptyQuery() {
        let events = [Event]()
        
        networkDataSource.dataSourceCompletionResult = .failure(NetworkError.authenticationFailure)
        viewMock.expectation = expectation(description: #function)
        
        presenter.queryEvents(query: "")
        waitForExpectations(timeout: 10, handler: nil)
        
        XCTAssertTrue(viewMock.setEventsCalled)
        XCTAssertEqual(viewMock.events, events)
        
        XCTAssertTrue(viewMock.setStateCalled)
        XCTAssertEqual(viewMock.state, EventSearchViewController.State.start)
    }
    
    func testQueryEvents_Success_Events() {
        var events = [Event]()
        for index in 0..<20 {
            let event = Event(id: index, title: "Title \(index)", date: Date(), city: "Austin", state: "TX", imageURL: nil)
            events.append(event)
        }
        
        networkDataSource.dataSourceCompletionResult = .success(events)
        viewMock.expectation = expectation(description: #function)
        
        presenter.queryEvents(query: "test")
        waitForExpectations(timeout: 10, handler: nil)
        
        XCTAssertTrue(viewMock.setEventsCalled)
        XCTAssertEqual(viewMock.events, events)
        
        XCTAssertTrue(viewMock.setStateCalled)
        XCTAssertEqual(viewMock.state, EventSearchViewController.State.events)
    }
    
    func testQueryEvents_Success_EmptyEvents() {
        let events = [Event]()
        
        networkDataSource.dataSourceCompletionResult = .success(events)
        viewMock.expectation = expectation(description: #function)
        
        presenter.queryEvents(query: "test")
        waitForExpectations(timeout: 10, handler: nil)
        
        XCTAssertTrue(viewMock.setEventsCalled)
        XCTAssertEqual(viewMock.events, events)
        
        XCTAssertTrue(viewMock.setStateCalled)
        XCTAssertEqual(viewMock.state, EventSearchViewController.State.empty)
    }
    
    func testQueryEvents_Failure() {
        networkDataSource.dataSourceCompletionResult = .failure(NetworkError.authenticationFailure)
        viewMock.expectation = expectation(description: #function)
        
        presenter.queryEvents(query: "test")
        waitForExpectations(timeout: 10, handler: nil)
        
        XCTAssertTrue(viewMock.presentAlertCalled)
        
        XCTAssertTrue(viewMock.setStateCalled)
        XCTAssertEqual(viewMock.state, EventSearchViewController.State.empty)
    }
}
