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
import SWXMLHash

class XMLDateParseTests: XCTestCase {
    func testTaskDate() {
        let string =
        """
        <?xml version="1.0" encoding="UTF-8"?>
        <task>
            <created-at type="datetime">2015-03-07T13:21:04Z</created-at>
        </task>
        """
        
        let xml = SWXMLHash.parse(string)
        
        let task = xml["task"]
        let createdAt = task["created-at"].element?.date
        XCTAssertNotNil(createdAt)
        XCTAssertTrue(createdAt?.isOn(year: 2015, month: 3, day: 7) ?? false)
    }
}
