//
//  embrace_outdoors_iosUITests.swift
//  embrace-outdoors-iosUITests
//
//  Created by David Rifkin on 8/13/24.
//

import XCTest

final class embrace_outdoors_iosUITests: XCTestCase {

    var app: XCUIApplication!
    
    lazy var actionSet = [
        tapNestedTracesButton,
        tapRequestConcurrentTraceButton,
        tapMockAuthTraceButton,
        tapMockSearchTraceButton,
        tapMockCheckoutTraceButton,
        tapMockPermissionsTraceButton,
        tapMockMiddlewareTraceButton,
        tapWorkingNetworkRequestButton,
        tapNSFNetworkRequestButton,
        tapUnauthorizedRequestButton,
//        tapPickerSelectorButton, TODO: Make this work
        tapTimeoutRequestButton
    ]
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()

    }

    override func tearDownWithError() throws {
        app = nil
    }

    func testFlow() throws {
        checkOnMainView()
        
        // pick number of sessions
        for _ in 0...getNumberOfSessions() {
            // Do stuff
            runNormalFlow()

            //Send to background to upload session
            backgroundApp()
            foregroundApp()
        }
        //Run one last session and background the app
        runNormalFlow()
        backgroundApp()
        XCTAssert(true)
    }
    
    //MARK: Test Script
    private func runNormalFlow() {
        // Do stuff
        runRandomActions()
        
        // Maybe crash
        calculateAndCreateCrash()
        
        // Do more stuff
        runRandomActions()
    }
    
    private func backgroundApp() {
        let settings = XCUIApplication(bundleIdentifier: "com.apple.Preferences")
        settings.launch()
    }
    
    private func foregroundApp() {
        app.activate()
    }
    
    private func runRandomActions() {
        for _ in 0...getNumberOfActions() {
            guard let action = actionSet.randomElement() else {continue}
            action()
        }
    }
    
    private func getNumberOfActions() -> Int {
        Int.random(in: 3...7)
    }
    
    private func getNumberOfSessions() -> Int {
        Int.random(in: 3...10)
    }
    
    private func calculateAndCreateCrash() {
        //TODO: Make this variable by device OS version
        let probability = Int.random(in: 0...99)
        if probability > 94 {
            tapCrashButton()
        }
    }

    //MARK: Navigation
    private func checkOnMainView() {
        let mainListView = app.collectionViews["main-list-view"]
        XCTAssertTrue(mainListView.waitForExistence(timeout: 2))
    }
    
    //MARK: Trace Actions
    private func tapNestedTracesButton(){
        checkOnMainView()
        let button = app.buttons["nested-traces-button"].firstMatch
        XCTAssertTrue(button.waitForExistence(timeout: 1))
        button.tap()
    }
    
    private func tapRequestConcurrentTraceButton(){
        checkOnMainView()
        let button = app.buttons["request-within-traces-button"].firstMatch
        XCTAssertTrue(button.waitForExistence(timeout: 1))
        button.tap()
    }
    
    private func tapMockAuthTraceButton(){
        checkOnMainView()
        let button = app.buttons["mock-auth-traces-button"].firstMatch
        XCTAssertTrue(button.waitForExistence(timeout: 1))
        button.tap()
    }
    
    private func tapMockSearchTraceButton(){
        checkOnMainView()
        let button = app.buttons["mock-search-traces-button"].firstMatch
        XCTAssertTrue(button.waitForExistence(timeout: 1))
        button.tap()
    }
    
    private func tapMockCheckoutTraceButton(){
        checkOnMainView()
        let button = app.buttons["mock-checkout-traces-button"].firstMatch
        XCTAssertTrue(button.waitForExistence(timeout: 1))
        button.tap()
    }
    
    private func tapMockPermissionsTraceButton(){
        checkOnMainView()
        let button = app.buttons["mock-permissions-traces-button"].firstMatch
        XCTAssertTrue(button.waitForExistence(timeout: 1))
        button.tap()
    }
    
    private func tapMockMiddlewareTraceButton(){
        checkOnMainView()
        let button = app.buttons["mock-middleware-traces-button"].firstMatch
        XCTAssertTrue(button.waitForExistence(timeout: 1))
        button.tap()
    }
    
    //MARK: Other Actions
    private func tapWorkingNetworkRequestButton(){
        checkOnMainView()
        let button = app.buttons["working-network-request-button"].firstMatch
        XCTAssertTrue(button.waitForExistence(timeout: 1))
        button.tap()
    }
    
    private func tapNSFNetworkRequestButton(){
        checkOnMainView()
        let button = app.buttons["nsf-request-button"].firstMatch
        XCTAssertTrue(button.waitForExistence(timeout: 1))
        button.tap()
    }
    
    private func tapUnauthorizedRequestButton(){
        checkOnMainView()
        let button = app.buttons["unauthorized-request-button"].firstMatch
        XCTAssertTrue(button.waitForExistence(timeout: 1))
        button.tap()
    }
    
    private func tapTimeoutRequestButton(){
        checkOnMainView()
        let button = app.buttons["timeout-request-button"].firstMatch
        XCTAssertTrue(button.waitForExistence(timeout: 1))
        button.tap()
    }

    private func tapCrashButton(){
        checkOnMainView()
        let button = app.buttons["force-crash-button"].firstMatch
        XCTAssertTrue(button.waitForExistence(timeout: 1))
        button.tap()
    }
    
    private func tapPickerSelectorButton(){
        //TODO: Make this work
        checkOnMainView()
        //UI ID: "states-picker"
    }

    private func tapParkResult(){
        //TODO: Make this work
        checkOnMainView()
        //UI ID: "networking-results-list-section"
    }
}
