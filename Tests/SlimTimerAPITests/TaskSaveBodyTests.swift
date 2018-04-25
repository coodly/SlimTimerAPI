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
@testable import SlimTimerAPI

class TaskSaveBodyTests: XCTestCase {
    func testWithOnlyName() {
        let task = Task(id: nil, name: "TestTask", createdAt: Date(), completedOn: nil, tags: [])
        let body = TaskSaveBody(task: task)
        
        let expected = [
            "<?xml version=\"1.0\" encoding=\"UTF-8\"?>",
            "<request>",
                "<task>",
                    "<completed_on></completed_on>",
                    "<name>TestTask</name>",
                    "<tags></tags>",
                "</task>",
            "</request>"
        ].joined()
        
        XCTAssertEqual(expected, body.generate())
    }

    func testWTaskRename() {
        let task = Task(id: 1234, name: "TestTasker", createdAt: Date(), completedOn: nil, tags: [])
        let body = TaskSaveBody(task: task)
        
        let expected = [
            "<?xml version=\"1.0\" encoding=\"UTF-8\"?>",
            "<request>",
                "<task>",
                    "<completed_on></completed_on>",
                    "<name>TestTasker</name>",
                    "<tags></tags>",
                "</task>",
            "</request>"
        ].joined()
        
        XCTAssertEqual(expected, body.generate())
    }
    
    func testTaskWithTags() {
        let task = Task(id: 1234, name: "TestTasker", createdAt: Date(), completedOn: nil, tags: ["shake", "bake", "cake"])
        let body = TaskSaveBody(task: task)
        
        let expected = [
            "<?xml version=\"1.0\" encoding=\"UTF-8\"?>",
            "<request>",
                "<task>",
                    "<completed_on></completed_on>",
                    "<name>TestTasker</name>",
                    "<tags>bake,cake,shake</tags>",
                "</task>",
            "</request>"
        ].joined()
        
        XCTAssertEqual(expected, body.generate())
    }

    func testCompletedTask() {
        let completedOn = Date.dateOn(year: 2017, month: 12, day: 12, hours: 12, minutes: 12, seconda: 12)

        let task = Task(id: 1234, name: "TestTasker", createdAt: Date(), completedOn: completedOn, tags: ["shake", "bake", "cake"])
        let body = TaskSaveBody(task: task)
        
        let expected = [
            "<?xml version=\"1.0\" encoding=\"UTF-8\"?>",
            "<request>",
                "<task>",
                    "<completed_on>2017-12-12T14:12:12Z</completed_on>",
                    "<name>TestTasker</name>",
                    "<tags>bake,cake,shake</tags>",
                "</task>",
            "</request>"
        ].joined()
        
        XCTAssertEqual(expected, body.generate())
    }
}
