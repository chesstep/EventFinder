//
//  EventLocalDataSourceTests.swift
//  EventFinderTests
//
//  Created by Chesley Stephens on 9/20/19.
//  Copyright © 2019 Nibbis. All rights reserved.
//

import XCTest
@testable import EventFinder

class EventLocalDataSourceTests: XCTestCase {
    
    var eventLocalDataSource: EventLocalDataSource!
    
    override func setUp() {
        eventLocalDataSource = EventLocalDataSource()
        eventLocalDataSource.favoriteCache = Cache(cacheName: "testEventsCache", useDiskCache: false)
    }
    
    override func tearDown() { }
    
    func testAddFavoriteEvent() {
        let event = Event(id: 1, title: "Batman", date: Date(), city: "Gotham", state: "Gotham", imageURL: nil)
        eventLocalDataSource.addFavoriteEvent(event: event)
        XCTAssertTrue(eventLocalDataSource.eventIsFavorite(event: event))
    }
    
    func testRemoveFavoriteEvent() {
        let event = Event(id: 1, title: "Batman", date: Date(), city: "Gotham", state: "Gotham", imageURL: nil)
        eventLocalDataSource.addFavoriteEvent(event: event)
        XCTAssertTrue(eventLocalDataSource.eventIsFavorite(event: event))
        
        eventLocalDataSource.removeFavoriteEvent(event: event)
        XCTAssertFalse(eventLocalDataSource.eventIsFavorite(event: event))
    }
}
