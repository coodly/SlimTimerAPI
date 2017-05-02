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
