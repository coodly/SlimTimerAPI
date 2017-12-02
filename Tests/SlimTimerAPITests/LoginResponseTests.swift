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

class LoginResponseTests: XCTestCase {
    func testSuccessResponse() {
        let success =
        """
        <?xml version="1.0" encoding="UTF-8"?>
        <response>
            <user-id type="integer">12</user-id>
            <access-token>api-token-123</access-token>
        </response>
        """
        
        let xml = SWXMLHash.parse(success)
        let model = LoginResponse(xml: xml)
        XCTAssertNotNil(model)
        
        guard let checked = model else {
            return
        }
        XCTAssertEqual(12, checked.userId)
        XCTAssertEqual("api-token-123", checked.token)
    }
    
    func testAuthFailureResonse() {
        let failure =
        """
        <?xml version="1.0" encoding="UTF-8"?>
        <errors>
            <error>Authentication failed</error>
        </errors>
        """

        let xml = SWXMLHash.parse(failure)
        XCTAssertTrue(xml.containsError)
        XCTAssertEqual("Authentication failed", xml.errorMessage)
    }
}
