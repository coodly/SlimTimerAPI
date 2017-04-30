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

class LoginResponseTests: XCTestCase {
    func testSuccessResponse() {
        let success = [
            "---",
            "user_id: 12",
            "access_token: api-token-123"
        ].joined(separator: "\n")
        
        let response = YAMLResponse(data: success.data(using: .utf8)!).parse()!
        let model = LoginResponse(yaml: response)
        XCTAssertNotNil(model)
        
        guard let checked = model else {
            return
        }
        XCTAssertEqual(12, checked.userId)
        XCTAssertEqual("api-token-123", checked.token)
    }
    
    func testAuthFailureResonse() {
        let failure = [
            "---",
            ":error: Authentication failed"
        ].joined(separator: "\n")

        let response = YAMLResponse(data: failure.data(using: .utf8)!).parse() as! [String: AnyObject]
        XCTAssertTrue(response.containsError())
        XCTAssertEqual("Authentication failed", response.errorMessage())
    }
}
