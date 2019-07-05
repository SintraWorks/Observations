//
//  ObservationsUITests.swift
//  ObservationsUITests
//
//  Created by Antonio Nunes on 14/05/2019.
//  Copyright © 2019 SintraWorks. All rights reserved.
//

import XCTest
@testable import Observations

class ObservationsUITests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testABunch() {
		let app = XCUIApplication()
		app.navigationBars["Show Actions"].buttons["Show Actions"].tap()
		app.buttons["Action 1"].tap()
		app.buttons["Action 2"].doubleTap()
		app.navigationBars["Observations.ObservableView"].buttons["Back"].tap()

		XCTAssertTrue(app.tables.cells.count == 3, "Incorrect number of cells")
		XCTAssertTrue(app.tables.cells.staticTexts["1 Remote action on button 1"].exists, "Incorrect row text")
		XCTAssertTrue(app.tables.cells.staticTexts["2 touchUpInside button 2"].exists, "Incorrect row text")
		XCTAssertTrue(app.tables.cells.staticTexts["3 touchUpInside button 2"].exists, "Incorrect row text")

		app.navigationBars["Show Actions"].buttons["Show Actions"].tap()
		app.sliders["0%"].swipeRight()

		app.navigationBars["Observations.ObservableView"].buttons["Back"].tap()

		XCTAssertTrue(app.tables.cells.count == 18, "Incorrect number of cells")
		XCTAssertTrue(app.tables.cells.staticTexts["18 is tracking: false"].exists, "Incorrect row text")

        let showActionsNavigationBar = app.navigationBars["Show Actions"]
        showActionsNavigationBar.buttons["Delete"].tap()
        XCTAssertTrue(app.tables.cells.count == 0, "There should be 0 cells after tapping the trash can")

        showActionsNavigationBar.buttons["Add"].tap()
        XCTAssertTrue(app.tables.cells.count == 1, "There should be 1 cell after tapping the plus button")
    }
}
