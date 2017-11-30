//
//  EntrySaveBodyTests.swift
//  SlimTimerAPITests
//
//  Created by Jaanus Siim on 30/11/2017.
//

import XCTest
@testable import SlimTimerAPI

class EntrySaveBodyTests: XCTestCase {
    func testWithOnlyTaskIdAndStartTime() {
        let start = Date.dateOn(year: 2017, month: 12, day: 12, hours: 12, minutes: 12, seconda: 12)
        let end = start.addingTimeInterval(12)
        let entry = Entry(id: nil, startTime: start, endTime: end, taskId: 123, tags: nil, comment: nil)
        let body = EntrySaveBody(entry: entry)
        
        let expected = [
            "<?xml version=\"1.0\" encoding=\"UTF-8\"?>",
            "<request>",
                "<time-entry>",
                    "<duration-in-seconds>12</duration-in-seconds>",
                    "<end-time>2017-12-12T12:12:24Z</end-time>",
                    "<in-progress>false</in-progress>",
                    "<start-time>2017-12-12T12:12:12Z</start-time>",
                    "<task-id>123</task-id>",
                "</time-entry>",
            "</request>"
        ].joined()
        
        XCTAssertEqual(expected, body.generate())
    }
}
