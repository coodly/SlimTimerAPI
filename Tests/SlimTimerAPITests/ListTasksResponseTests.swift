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

class ListTasksResponseTests: XCTestCase {
    func testSingleTaskInResponse() {
        let success = [
            "- coworkers: []",
            "",
            "  name: Review apps",
            "  created_at: 2014-01-11 16:51:43.114355 Z",
            "  completed_on:",
            "  owners:",
            "  - name: Apple",
            "    user_id: 1",
            "    email: cc@cc.com",
            "  updated_at: 2014-01-11 16:51:43.114355 Z",
            "  role: owner",
            "  tags: \"\"",
            "  id: 1",
            "  reporters: []",
            "",
            "  hours: 10.02",
        ].joined(separator: "\n")
        
        guard let response = YAMLResponse(data: success.data(using: .utf8)!).parse() as? [[String: AnyObject]] else {
            XCTAssertFalse(true)
            return
        }
        XCTAssertEqual(1, response.count)
    }

    func testTwoTasksInResponse() {
        let success = [
            "---",
            "- coworkers: []",
            "",
            "  name: Review apps",
            "  created_at: 2014-01-11 16:51:43.114355 Z",
            "  completed_on:",
            "  owners:",
            "  - name: Apple",
            "    user_id: 1",
            "    email: cc@cc.com",
            "  updated_at: 2014-01-11 16:51:43.114355 Z",
            "  role: owner",
            "  tags: \"\"",
            "  id: 1",
            "  reporters: []",
            "",
            "  hours: 10.02",
            "- coworkers: []",
            "",
            "  name: Review apps",
            "  created_at: 2014-01-11 16:51:43.114355 Z",
            "  completed_on:",
            "  owners:",
            "  - name: Apple",
            "    user_id: 1",
            "    email: cc@cc.com",
            "  updated_at: 2014-01-11 16:51:43.114355 Z",
            "  role: owner",
            "  tags: \"\"",
            "  id: 2",
            "  reporters: []",
            "",
            "  hours: 10.02",
        ].joined(separator: "\n")
        
        guard let response = YAMLResponse(data: success.data(using: .utf8)!).parse() as? [[String: AnyObject]] else {
            XCTAssertFalse(true)
            return
        }
        XCTAssertEqual(2, response.count)
    }
}
