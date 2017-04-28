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

class LoginRequestBodyTests: XCTestCase {
    func testGeneratedXML() {
        let body = LoginRequestBody(email: "cc@cc.com", password: "123")
        body.apiKey = "api-key-122344"
        
        let generated = body.generate()
        
        let expected = ["<?xml version=\"1.0\" encoding=\"UTF-8\"?>",
            "<request>",
            "<api-key>",
            "api-key-122344",
            "</api-key>",
            "<user>",
            "<email>",
            "cc@cc.com",
            "</email>",
            "<password>",
            "123",
            "</password>",
            "</user>",
            "</request>"
        ].joined()
        
        XCTAssertEqual(expected, generated)
    }
}
