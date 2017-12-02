//
//  ParseTasksTests.swift
//  SlimTimerAPITests
//
//  Created by Jaanus Siim on 02/12/2017.
//

import XCTest
import SWXMLHash
@testable import SlimTimerAPI

class ParseTasksTests: XCTestCase {
    func testParseTwoTasks() {
        let input =
        """
        <?xml version="1.0" encoding="UTF-8"?>
        <tasks>
          <task>
            <coworkers>
            </coworkers>
            <name>Review apps</name>
            <created-at type="datetime">2014-01-11T16:51:43Z</created-at>
            <completed-on nil="true"></completed-on>
            <owners>
              <person>
                <name>Apple</name>
                <user-id type="integer">119695</user-id>
                <email>cc@cc.com</email>
              </person>
            </owners>
            <updated-at type="datetime">2014-01-11T16:51:43Z</updated-at>
            <role>owner</role>
            <tags></tags>
            <id type="integer">2267906</id>
            <reporters>
            </reporters>
            <hours type="float">10.02</hours>
          </task>
          <task>
            <coworkers>
            </coworkers>
            <name>Jogging</name>
            <created-at type="datetime">2015-03-07T13:21:04Z</created-at>
            <completed-on nil="true"></completed-on>
            <owners>
              <person>
                <name>Apple</name>
                <user-id type="integer">119695</user-id>
                <email>cc@cc.com</email>
              </person>
            </owners>
            <updated-at type="datetime">2015-03-07T13:21:04Z</updated-at>
            <role>owner</role>
            <tags></tags>
            <id type="integer">2536935</id>
            <reporters>
            </reporters>
            <hours type="float">0.02</hours>
          </task>
        </tasks>
        """
        
        let xml = SWXMLHash.parse(input)
        let tasks = Tasks(xml: xml)
        
        XCTAssertEqual(2, tasks?.tasks.count)
        XCTAssertEqual(2267906, tasks?.tasks.first?.id)
        XCTAssertEqual(2536935, tasks?.tasks.last?.id)
    }
}
