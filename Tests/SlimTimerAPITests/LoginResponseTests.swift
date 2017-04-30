//
//  LoginResponseTests.swift
//  SlimTimerAPI
//
//  Created by Jaanus Siim on 28/04/2017.
//
//

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
