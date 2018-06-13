/*
 * Copyright 2018 Coodly LLC
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

class LoadRawTimeEntryDetailsTests: XCTestCase {
    func testDurationFromServerLoaded() {
        let input =
        """
        <?xml version="1.0" encoding="UTF-8"?>
        <time-entry>
            <end-time type="datetime">2018-05-30T07:55:46Z</end-time>
            <created-at type="datetime">2018-05-30T04:54:47Z</created-at>
            <comments>Work on details on tv</comments>
            <updated-at type="datetime">2018-05-30T05:44:53Z</updated-at>
            <tags>tvOS</tags>
            <id type="integer">35011011</id>
            <duration-in-seconds type="integer">3006</duration-in-seconds>
            <task>
              <coworkers>
              </coworkers>
              <name>Coodly - Moviez</name>
              <created-at type="datetime">2016-04-25T16:08:08Z</created-at>
              <completed-on nil="true"></completed-on>
              <owners>
                <person>
                  <name>Jaanus Siim</name>
                  <user-id type="integer">63416</user-id>
                  <email>jaanus@jaanussiim.com</email>
                </person>
              </owners>
              <updated-at type="datetime">2016-04-25T16:08:08Z</updated-at>
              <role>owner</role>
              <tags>coodly,ios</tags>
              <id type="integer">2714377</id>
              <reporters>
              </reporters>
              <hours type="float">715.28</hours>
            </task>
            <in-progress type="boolean">true</in-progress>
            <start-time type="datetime">2018-05-30T07:54:46Z</start-time>
        </time-entry>
        """
        
        let xml = SWXMLHash.parse(input)
        
        guard let entry = Entry(xml: xml) else {
            XCTAssertTrue(false)
            return
        }
        
        XCTAssertTrue(entry.inProgress)
        XCTAssertNotNil(entry.endTime)
        XCTAssertEqual(3006, entry.durationInSeconds)
    }}
