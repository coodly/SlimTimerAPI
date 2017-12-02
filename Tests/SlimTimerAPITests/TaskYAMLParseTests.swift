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

class TaskYAMLParseTests: XCTestCase {
    func testTaskParse() {
        let text =
        """
          <task>
            <coworkers>
            </coworkers>
            <name>Game development</name>
            <created-at type="datetime">2015-03-07T13:19:14Z</created-at>
            <completed-on nil="true"></completed-on>
            <owners>
              <person>
                <name>Apple</name>
                <user-id type="integer">119695</user-id>
                <email>cc@cc.com</email>
              </person>
            </owners>
            <updated-at type="datetime">2015-03-12T13:19:14Z</updated-at>
            <role>owner</role>
            <tags>apps,ios</tags>
            <id type="integer">2536931</id>
            <reporters>
            </reporters>
            <hours type="float">1.02</hours>
          </task>
        """
        let xml = SWXMLHash.parse(text)
        
        guard let task = Task(xml: xml) else {
            XCTAssertFalse(true)
            return
        }
        
        XCTAssertEqual("Game development", task.name)
        XCTAssertTrue(task.createdAt.isOn(year: 2015, month: 03, day: 07))
        XCTAssertNil(task.completedOn)
        XCTAssertTrue(task.updatedAt.isOn(year: 2015, month: 03, day: 12))
        XCTAssertEqual(2, task.tags.count)
        XCTAssertEqual(2536931, task.id)
        XCTAssertEqual(1.02, task.hours)
    }
}
