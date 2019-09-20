//
//  EventFinderUITests.swift
//  EventFinderUITests
//
//  Created by Chesley Stephens on 9/19/19.
//  Copyright © 2019 Nibbis. All rights reserved.
//

import XCTest

class EventFinderUITests: XCTestCase {

    override func setUp() {
        continueAfterFailure = false
        
        let app = XCUIApplication()
        app.launchArguments = ["UI-Testing"]
        app.launch()
    }

    func testSmoke() {
        XCUIApplication().searchFields["Search Events"].tap()
        
        let app = XCUIApplication()
        let searchField = app.searchFields["Search Events"]
        searchField.tap()
        searchField.typeText("Texas")
        
        let activityIndicator = app.activityIndicators["In progress"]
        let _ = expectation(for: NSPredicate(format: "exists != 1"), evaluatedWith: activityIndicator, handler: nil)
        waitForExpectations(timeout: 10, handler: nil)
        
        let cells = app.tables.cells
        XCTAssertTrue(cells.count > 0)
        app.cells.element(boundBy: 0).tap()
        
        let navigationBar = app.navigationBars.element(boundBy: 0)
        let starButton = navigationBar.buttons["star empty"]
        starButton.tap()
        
        navigationBar.buttons["Event Finder"].tap()
        
        app.searchFields["Search Events"].buttons["Clear text"].tap()
        let _ = expectation(for: NSPredicate(format: "exists == 1"), evaluatedWith: app.staticTexts["Use the search bar above to begin finding events"], handler: nil)
        waitForExpectations(timeout: 10, handler: nil)
        
        app.buttons["Cancel"].tap()
    }
}
