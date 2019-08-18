//
//  CedarUITests.swift
//  CedarUITests
//
//  Created by Patrick Mick on 7/21/19.
//  Copyright © 2019 Patrick Mick. All rights reserved.
//

import XCTest

class CedarUITests: XCTestCase {
    func testHabitCreationAndDeletion() {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        
        XCTContext.runActivity(named: "Add new habit") { _ in
            app.buttons["Add New Habit"].tap()
            app.textFields["Title"].tap()
            app.typeText("Test")
            app.textFields["Reason"].tap()
            app.typeText("A cool reason")
            app.buttons["Add"].tap()
        }
        
        XCTContext.runActivity(named: "Delete habit") { _ in
            app.buttons["Test\nA cool reason"].tap()
            app.buttons["Delete"].tap()
            XCTAssertFalse(app.buttons["Test\nA cool reason"].exists)
        }
    }

    func testLaunchPerformance() {
        measure(metrics: [XCTOSSignpostMetric.applicationLaunch]) {
            XCUIApplication().launch()
        }
    }
}
