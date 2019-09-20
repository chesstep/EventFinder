//
//  EventDetailPresenterTests.swift
//  EventFinderTests
//
//  Created by Chesley Stephens on 9/20/19.
//  Copyright © 2019 Nibbis. All rights reserved.
//

import XCTest
@testable import EventFinder

class EventDetailViewMock: EventDetailView {
    
    var showEmptyButtonImageCalled = false
    var showFilledButtonImageCalled = false
    
    func showEmptyButtonImage() {
        showEmptyButtonImageCalled = true
    }
    
    func showFilledButtonImage() {
        showFilledButtonImageCalled = true
    }
}

class EventDetailPresenterTests: XCTestCase {
    
    var appConfiguration: AppConfiguration!
    
    var presenter: EventDetailPresenter!
    var viewMock: EventDetailViewMock!
    
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
        
        viewMock = EventDetailViewMock()
        presenter = EventDetailPresenter(appConfiguration: appConfiguration)
        
        presenter.attachView(view: viewMock)
    }
    
    override func tearDown() {
        presenter.detachView()
    }
    
    func testConfigureButtonImage_IsFavorite() {
        let event = Event(id: 1, title: "Batman", date: Date(), city: "Gotham", state: "Gotham", imageURL: nil)
        eventRepository.addFavorite(event: event)
        
        presenter.configureButtonImage(event: event)
        XCTAssertTrue(viewMock.showFilledButtonImageCalled)
    }
    
    func testConfigureButtonImage_NotFavorite() {
        let event = Event(id: 1, title: "Batman", date: Date(), city: "Gotham", state: "Gotham", imageURL: nil)
        
        presenter.configureButtonImage(event: event)
        XCTAssertTrue(viewMock.showEmptyButtonImageCalled)
    }
    
    func testRightBarButtonPressed_WasFavorite() {
        let event = Event(id: 1, title: "Batman", date: Date(), city: "Gotham", state: "Gotham", imageURL: nil)
        eventRepository.addFavorite(event: event)
        
        presenter.rightBarButtonPressed(event: event)
        XCTAssertTrue(viewMock.showEmptyButtonImageCalled)
    }
    
    func testRightBarButtonPressed_WasNotFavorite() {
        let event = Event(id: 1, title: "Batman", date: Date(), city: "Gotham", state: "Gotham", imageURL: nil)
        
        presenter.rightBarButtonPressed(event: event)
        XCTAssertTrue(viewMock.showFilledButtonImageCalled)
    }
}
