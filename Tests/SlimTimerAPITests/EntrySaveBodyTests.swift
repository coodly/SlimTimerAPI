/*
 * Copyright 2017 Coodly LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import XCTest
@testable import SlimTimerAPI

class EntrySaveBodyTests: XCTestCase {
    func testWithOnlyTaskIdAndStartTime() {
        let start = Date.dateOn(year: 2017, month: 12, day: 12, hours: 12, minutes: 12, seconda: 12)
        let end = start.addingTimeInterval(12)
        let entry = Entry(id: nil, startTime: start, endTime: end, taskId: 123, tags: nil, comments: nil)
        let body = EntrySaveBody(entry: entry)
        
        let expected = [
            "<?xml version=\"1.0\" encoding=\"UTF-8\"?>",
            "<request>",
                "<time-entry>",
                    "<duration-in-seconds>60</duration-in-seconds>",
                    "<end-time>2017-12-12T12:12:24Z</end-time>",
                    "<in-progress>false</in-progress>",
                    "<start-time>2017-12-12T12:12:12Z</start-time>",
                    "<task-id>123</task-id>",
                "</time-entry>",
            "</request>"
        ].joined()
        
        XCTAssertEqual(expected, body.generate())
    }
    
    func testAllValuesPresent() {
        let start = Date.dateOn(year: 2017, month: 12, day: 13, hours: 14, minutes: 15, seconda: 16)
        let end = start.addingTimeInterval(120)
        let entry = Entry(id: 321, startTime: start, endTime: end, taskId: 124, tags: ["cake", "shake", "bake"], comments: "The commentator")
        let body = EntrySaveBody(entry: entry)
        
        let expected = [
            "<?xml version=\"1.0\" encoding=\"UTF-8\"?>",
            "<request>",
                "<time-entry>",
                    "<comments>The commentator</comments>",
                    "<duration-in-seconds>120</duration-in-seconds>",
                    "<end-time>2017-12-13T14:17:16Z</end-time>",
                    "<in-progress>false</in-progress>",
                    "<start-time>2017-12-13T14:15:16Z</start-time>",
                    "<tags>bake,cake,shake</tags>",
                    "<task-id>124</task-id>",
                "</time-entry>",
            "</request>"
        ].joined()
        
        XCTAssertEqual(expected, body.generate())
    }
}
