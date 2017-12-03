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
import SWXMLHash
@testable import SlimTimerAPI

class LoadTimeEntryTests: XCTestCase {
    func testLoadSingleEntry() {
        let input =
        """
        <?xml version="1.0" encoding="UTF-8"?>
        <time-entry>
          <end-time type="datetime">2017-12-02T14:32:49Z</end-time>
          <created-at type="datetime">2017-12-02T14:32:51Z</created-at>
          <comments nil="true"></comments>
          <updated-at type="datetime">2017-12-02T14:32:51Z</updated-at>
          <tags></tags>
          <id type="integer">34493431</id>
          <duration-in-seconds type="integer">93346</duration-in-seconds>
          <task>
            <coworkers>
            </coworkers>
            <name>Reading</name>
            <created-at type="datetime">2015-03-07T13:22:24Z</created-at>
            <completed-on nil="true"></completed-on>
            <owners>
              <person>
                <name>Apple</name>
                <user-id type="integer">119695</user-id>
                <email>cc@cc.com</email>
              </person>
            </owners>
            <updated-at type="datetime">2015-03-07T13:22:24Z</updated-at>
            <role>owner</role>
            <tags></tags>
            <id type="integer">2536937</id>
            <reporters>
            </reporters>
            <hours type="float">1.93</hours>
          </task>
          <in-progress type="boolean">true</in-progress>
          <start-time type="datetime">2017-12-01T12:37:03Z</start-time>
        </time-entry>
        """
        
        let xml = SWXMLHash.parse(input)
        
        guard let entry = Entry(xml: xml) else {
            XCTAssertTrue(false)
            return
        }
        
        XCTAssertNil(entry.endTime)
        XCTAssertTrue(entry.startTime.isOn(year: 2017, month: 12, day: 1))
        XCTAssertEqual(34493431, entry.id ?? 0)
        XCTAssertEqual(93346, entry.durationInSeconds)
        XCTAssertEqual(2536937, entry.task?.id ?? 0)
    }
}
