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

class ArrayYAMLTests: XCTestCase {
    func testHasNoSubItems() {
        let lines = [
            "  name: cake",
            "  place: fake"
        ]
        
        XCTAssertFalse(lines.containsSubItems())
    }
    
    func testhasSubItemAtBeginning() {
        let lines = [
            "  movies:",
            "  - title: In the woods",
            "    genre: Comedy",
            "  name: cake",
            "  place: fake"
        ]
        
        XCTAssertTrue(lines.containsSubItems())
    }

    func testExtractSubItem() {
        let lines = [
            "  movies:",
            "  - title: In the woods",
            "    genre: Comedy",
            "  - title: Fake cake",
            "    genre: Drama",
            "  name: cake",
            "  place: fake"
        ]
        
        let extract = lines.extractSubItem()
        
        XCTAssertEqual(2, extract.remaining.count)
        
        guard let movies = extract.sub["movies"] as? [[String: AnyObject]] else {
            XCTAssertFalse(true)
            return
        }
        
        XCTAssertEqual(2, movies.count)
    }
}
