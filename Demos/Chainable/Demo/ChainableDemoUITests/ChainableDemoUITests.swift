//
//  ChainableDemoUITests.swift
//  ChainableDemoUITests
//
//  Created by weiwei.li on 2019/1/10.
//  Copyright © 2019 dd01.leo. All rights reserved.
//

import XCTest

class ChainableDemoUITests: XCTestCase {
    let app = XCUIApplication()

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

    func testExample() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        testTextField()
//        testView()
        
    }
    
    func testTextField() {
        app.tables.staticTexts["1、UITextField"].tap()

        for i in 0..<100 {
            print("第\(i)次")
            let input1TextField = app.textFields["我是input1"]
            input1TextField.tap()
            input1TextField.tap()
            input1TextField.typeText("1123")
            sleep(1)
            app.otherElements.containing(.navigationBar, identifier:"ChainableDemo.TextFieldVC").children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.tap()
//            app.navigationBars["ChainableDemo.TextFieldVC"].buttons["Back"].tap()
        }
    }
    
    func testView() {
            app.tables/*@START_MENU_TOKEN@*/.staticTexts["2、UIKit+Chainable(UIView，UILabel， UIButton, UIImageView等.....)"]/*[[".cells.staticTexts[\"2、UIKit+Chainable(UIView，UILabel， UIButton, UIImageView等.....)\"]",".staticTexts[\"2、UIKit+Chainable(UIView，UILabel， UIButton, UIImageView等.....)\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
            app.sliders["0%"].swipeRight()
            
            let app2 = app
            app2/*@START_MENU_TOKEN@*/.buttons["吕布"]/*[[".segmentedControls.buttons[\"吕布\"]",".buttons[\"吕布\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
            app2/*@START_MENU_TOKEN@*/.buttons["曹操"]/*[[".segmentedControls.buttons[\"曹操\"]",".buttons[\"曹操\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
            app2/*@START_MENU_TOKEN@*/.buttons["白起"]/*[[".segmentedControls.buttons[\"白起\"]",".buttons[\"白起\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
            app.buttons["按钮"].tap()
            
            let navIconBackBlackImage = app.images["nav_icon_back_black"]
            navIconBackBlackImage.tap()
            navIconBackBlackImage.tap()
            
            let element = app.otherElements.containing(.navigationBar, identifier:"ChainableDemo.UIKitChainableVC").children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element
            element.tap()
            element.tap()
        }
    
}
