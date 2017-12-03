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

class LoadMultipleEntriesTests: XCTestCase {
    func testLoadMultipleEntries() {
        let input =
        """
        <?xml version="1.0" encoding="UTF-8"?>
        <time-entries>
          <time-entry>
            <end-time type="datetime">2017-12-02T15:19:22Z</end-time>
            <created-at type="datetime">2017-12-03T06:12:31Z</created-at>
            <comments nil="true"></comments>
            <updated-at type="datetime">2017-12-03T06:12:31Z</updated-at>
            <tags></tags>
            <id type="integer">34493713</id>
            <duration-in-seconds type="integer">79</duration-in-seconds>
            <task>
              <coworkers>
              </coworkers>
              <name>Review apps</name>
              <created-at type="datetime">2014-01-11T16:51:43Z</created-at>
              <completed-on nil="true"></completed-on>
              <owners>
                <person>
                  <name>Apple</name>
                  <user-id type="integer">119695</user-id>
                  <email>jaanuscc@cc.com</email>
                </person>
              </owners>
              <updated-at type="datetime">2014-01-11T16:51:43Z</updated-at>
              <role>owner</role>
              <tags></tags>
              <id type="integer">2267906</id>
              <reporters>
              </reporters>
              <hours type="float">10.04</hours>
            </task>
            <in-progress type="boolean">false</in-progress>
            <start-time type="datetime">2017-12-02T15:18:02Z</start-time>
          </time-entry>
          <time-entry>
            <end-time type="datetime">2017-12-02T15:50:45Z</end-time>
            <created-at type="datetime">2017-12-02T15:50:29Z</created-at>
            <comments nil="true"></comments>
            <updated-at type="datetime">2017-12-02T15:50:46Z</updated-at>
            <tags></tags>
            <id type="integer">34493460</id>
            <duration-in-seconds type="integer">60</duration-in-seconds>
            <task>
              <coworkers>
              </coworkers>
              <name>The Secret Project</name>
              <created-at type="datetime">2015-03-07T13:21:28Z</created-at>
              <completed-on nil="true"></completed-on>
              <owners>
                <person>
                  <name>Apple</name>
                  <user-id type="integer">119695</user-id>
                  <email>cc@cc.com</email>
                </person>
              </owners>
              <updated-at type="datetime">2015-03-07T13:21:28Z</updated-at>
              <role>owner</role>
              <tags></tags>
              <id type="integer">2536936</id>
              <reporters>
              </reporters>
              <hours type="float">0.02</hours>
            </task>
            <in-progress type="boolean">false</in-progress>
            <start-time type="datetime">2017-12-02T15:50:28Z</start-time>
          </time-entry>
          <time-entry>
            <end-time type="datetime">2017-12-02T15:26:37Z</end-time>
            <created-at type="datetime">2017-12-02T15:19:31Z</created-at>
            <comments nil="true"></comments>
            <updated-at type="datetime">2017-12-02T15:26:39Z</updated-at>
            <tags></tags>
            <id type="integer">34493451</id>
            <duration-in-seconds type="integer">427</duration-in-seconds>
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
              <hours type="float">4.52</hours>
            </task>
            <in-progress type="boolean">false</in-progress>
            <start-time type="datetime">2017-12-02T15:19:30Z</start-time>
          </time-entry>
        </time-entries>
        """
        
        let xml = SWXMLHash.parse(input)
        guard let entries = Entries(xml: xml) else {
            XCTAssertFalse(true)
            return
        }
        
        XCTAssertEqual(3, entries.entries.count)
    }
}
