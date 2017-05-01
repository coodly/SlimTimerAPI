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

class TaskYAMLParseTests: XCTestCase {
    func testTaskParse() {
        let input = [
            "coworkers: []",
            "",
            "name: Game development",
            "created_at: 2015-03-07 13:19:14.078997 Z",
            "completed_on:",
            "owners:",
            "- name: Apple",
            "  user_id: 119695",
            "  email: cc@cc.com",
            "updated_at: 2015-03-12 13:19:14.078997 Z",
            "role: owner",
            "tags: apps,ios",
            "id: 2536931",
            "reporters: []",
            "",
            "hours: 1.02"
        ].dict()
        
        guard let task = Task(yaml: input as AnyObject) else {
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
