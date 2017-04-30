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

class YAMLResponseTests: XCTestCase {
    func testWithoutYAMLStartMarker() {
        let input = [
            "cake: 12",
            "mini: me",
        ].joined(separator: "\n")
        
        XCTAssertNil(YAMLResponse(data: input.data(using: .utf8)!).parse())
    }
    
    func testDictAtRoot() {
        let input = [
            "---",
            "cake: 12",
            "mini: me",
        ].joined(separator: "\n")
        
        guard let response = YAMLResponse(data: input.data(using: .utf8)!).parse() as? [String: AnyObject] else {
            XCTAssertFalse(true)
            return
        }
        
        XCTAssertEqual(12, response.int(for: "cake"))
        XCTAssertEqual("me", response.string(for: "mini"))
    }
    
    func testArrayOfDictionaries() {
        let input = [
            "---",
            "- beer: good",
            "  wine: me",
            "  vodka: bad",
            "- beer: cake",
            "  wine: shake",
            "  vodka: bake"
        ].joined(separator: "\n")

        guard let response = YAMLResponse(data: input.data(using: .utf8)!).parse() as? [[String: AnyObject]] else {
            XCTAssertFalse(true)
            return
        }
        
        XCTAssertEqual(2, response.count)
        
        guard let checked = response.first, let second = response.last else {
            XCTAssertFalse(true)
            return
        }
        
        XCTAssertEqual("good", checked.string(for: "beer"))
        XCTAssertEqual("me", checked.string(for: "wine"))
        XCTAssertEqual("bad", checked.string(for: "vodka"))

        XCTAssertEqual("cake", second.string(for: "beer"))
        XCTAssertEqual("shake", second.string(for: "wine"))
        XCTAssertEqual("bake", second.string(for: "vodka"))
    }
    
    func testWithNestedDictionaries() {
        let input = [
            "---",
            "- level_one: true",
            "  variable: 12",
            "  cakes: good",
            "  level_2:",
            "  - subbed: true",
            "    basement: floor",
            "  more: level",
            "- level_one: true",
            "  variable: 13",
            "  cakes: good",
            "  level_2:",
            "  - subbed: true",
            "    basement: attic",
            "  more: Nothing to see here",
        ].joined(separator: "\n")
        
        guard let response = YAMLResponse(data: input.data(using: .utf8)!).parse() as? [[String: AnyObject]] else {
            XCTAssertFalse(true)
            return
        }
        
        XCTAssertEqual(2, response.count)
        
        guard let first = response.first, let second = response.last else {
            XCTAssertFalse(true)
            return
        }

        XCTAssertEqual(4, first.count)
        XCTAssertEqual(4, second.count)
        
        XCTAssertEqual(true, second.bool(for: "level_one"))
        XCTAssertEqual(13, second.int(for: "variable"))
        XCTAssertEqual("good", second.string(for: "cakes"))
        XCTAssertEqual("Nothing to see here", second.string(for: "more"))
        
        guard let sub = second["level_2"] as? [String: AnyObject] else {
            XCTAssertFalse(true)
            return
        }
        
        XCTAssertEqual(true, sub.bool(for: "subbed"))
        XCTAssertEqual("attic", sub.string(for: "basement"))
    }
    
    func testHaveEmptyChildValue() {
        let input = [
            "---",
            "- coworkers: []",
            "",
            "  name: Review apps",
        ].joined(separator: "\n")
        
        guard let response = YAMLResponse(data: input.data(using: .utf8)!).parse() as? [[String: AnyObject]], let checked = response.first else {
            XCTAssertFalse(true)
            return
        }
        
        XCTAssertEqual(1, checked.count)
        XCTAssertNil(checked["coworkers"])
        XCTAssertEqual("Review apps", checked.string(for: "name"))
    }
    
    func testHaveEmptyStringValue() {
        let input = [
            "---",
            "- name: Review apps",
            "  created_at: 2014-01-11 16:51:43.114355 Z",
            "  completed_on:",
            "  owners:",
            "  tags: \"\"",
            "  hours: 10.02"
        ].joined(separator: "\n")
        
        guard let response = YAMLResponse(data: input.data(using: .utf8)!).parse() as? [[String: AnyObject]], let checked = response.first else {
            XCTAssertFalse(true)
            return
        }

        XCTAssertEqual(4, checked.count)
        XCTAssertEqual("", checked.string(for: "tags"))
    }
}
