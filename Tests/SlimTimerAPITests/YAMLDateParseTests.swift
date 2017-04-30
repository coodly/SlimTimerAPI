//
//  YAMLDateParseTests.swift
//  SlimTimerAPI
//
//  Created by Jaanus Siim on 30/04/2017.
//
//

import XCTest
@testable import SlimTimerAPI

class YAMLDateParseTests: XCTestCase {
    func testDateParse() {
        let testDict = ["created_at": "2014-01-11 16:51:43.114355 Z"]
        
        let result = testDict.date(for: "created_at")
        XCTAssertNotNil(result)
        
        let timeZone = TimeZone(secondsFromGMT: 0)
        let components = DateComponents(timeZone: timeZone, year: 2014, month: 01, day: 11, hour: 16, minute: 51, second: 43)
        let expected = Calendar(identifier: .gregorian).date(from: components)
        
        XCTAssertEqual(expected, result)
    }
}
