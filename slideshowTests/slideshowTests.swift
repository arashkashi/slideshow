//
//  slideshowTests.swift
//  slideshowTests
//
//  Created by Arash Kashi on 10/6/16.
//  Copyright © 2016 Arash Kashi. All rights reserved.
//

import XCTest
@testable import slideshow

class slideshowTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testCase_one() {
        
        let vc = ViewController()
        
        let views = vc.getMeViews(8)
        
        let offsets = vc.shuffleOffsets(views, eachOffset: 5.0, numberOfSlidedCards: 2)
        
        XCTAssertEqual(offsets.count, 2)
        XCTAssertEqual(offsets[0], 10.0)
        XCTAssertEqual(offsets[1], 5.0)
    }
    
    func testCase_two() {
        
        let vc = ViewController()
        
        let views = vc.getMeViews(3)
        
        let offsets = vc.shuffleOffsets(views, eachOffset: 5.0, numberOfSlidedCards: 4)
        
        XCTAssertEqual(offsets.count, 2)
        XCTAssertEqual(offsets[1], 5.0)
        XCTAssertEqual(offsets[0], 10.0)
    }

    
}
