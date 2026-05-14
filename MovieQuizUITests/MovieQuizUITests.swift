//
//  MovieQuizUITests.swift
//  MovieQuizUITests
//
//  Created by Артем Бобриков on 13.05.2026.
//

import XCTest

final class MovieQuizUITests: XCTestCase {
    
    var app: XCUIApplication!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        try super.setUpWithError()
        
        app = XCUIApplication()
        app.launch()

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        try super.tearDownWithError()
        
        app.terminate()
        app = nil
    }

    @MainActor
    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // XCUIAutomation Documentation
        // https://developer.apple.com/documentation/xcuiautomation
    }
    
    func testYesButton() throws {
        sleep(3)
        let firstPoster = app.images["Poster"]
        let firstPosterData = firstPoster.screenshot().pngRepresentation
        let firstIndex = app.staticTexts["Index"].label
        
        app.buttons["Yes"].tap()
        
        sleep(3)
        let secondPoster = app.images["Poster"]
        let secondPosterData = secondPoster.screenshot().pngRepresentation
        let secondIndex = app.staticTexts["Index"].label
        
        XCTAssertNotEqual(firstPosterData, secondPosterData)
        XCTAssertEqual(firstIndex, "1/10")
        XCTAssertEqual(secondIndex, "2/10")
    }
    
    func testNoButton() throws {
        sleep(3)
        let firstPoster = app.images["Poster"]
        let firstPosterData = firstPoster.screenshot().pngRepresentation
        
        app.buttons["No"].tap()
        
        sleep(3)
        let secondPoster = app.images["Poster"]
        let secondPosterData = secondPoster.screenshot().pngRepresentation
        let secondIndex = app.staticTexts["Index"].label
        
        XCTAssertNotEqual(firstPosterData, secondPosterData)
        XCTAssertEqual(secondIndex, "2/10")
    }
    
    func testGameFinish() throws {
        sleep(3)
        
        for _ in 1...10 {
            app.buttons["Yes"].tap()
            sleep(3)
        }
        
        let alert = app.alerts["Этот раунд окончен!"]
        
        XCTAssertTrue(alert.exists)
        XCTAssertTrue(alert.label == "Этот раунд окончен!")
        XCTAssertTrue(alert.buttons.firstMatch.label == "Сыграть ещё раз")
    }
    
    func testIndexAndNewGame() throws {
        sleep(3)
        let indexLabel = app.staticTexts["Index"]
        
        for n in 1...10 {
            XCTAssertEqual(indexLabel.label, "\(n)/10")
            app.buttons["Yes"].tap()
            sleep(3)
        }
        
        let alert = app.alerts["Этот раунд окончен!"]
        
        alert.buttons.firstMatch.tap()
        
        sleep(3)
        XCTAssertEqual(indexLabel.label, "1/10")
    }
    
}
