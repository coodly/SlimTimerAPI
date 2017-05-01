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

import Foundation

@available(OSX 10.12, iOS 10.0, *)
private extension ISO8601DateFormatter {
    static let slimTimerDateFormatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withFullDate, .withSpaceBetweenDateAndTime, .withFullTime]
        return formatter
    }()
}

extension Dictionary {
    func string(for key: String) -> String? {
        let dict = self as NSDictionary
        guard let value = dict[key] as? String else {
            return nil
        }
        
        if value == "\"\"" {
            return ""
        }
        
        return value
    }
    
    func int(for key: String) -> Int? {
        let dict = self as NSDictionary
        let value = dict[key]
        
        if let number = value as? Int {
            return number
        }
        
        if let string = value as? String, let number = Int(string) {
            return number
        }
        
        return nil
    }
    
    func bool(for key: String) -> Bool? {
        let dict = self as NSDictionary
        let value = dict[key]
        
        if let bool = value as? Bool {
            return bool
        }
        
        if let string = value as? String, let bool = Bool(string) {
            return bool
        }
        
        return nil
    }
    
    func date(for key: String) -> Date? {
        let dict = self as NSDictionary
        guard var string = dict[key] as? String else {
            return nil
        }
        
        if let index = string.range(of: ".", options: [.backwards]) {
            string = string.substring(to: index.lowerBound)
            string.append("+0000")
        }
        
        if #available(OSX 10.12, iOS 10.0, *) {
            return ISO8601DateFormatter.slimTimerDateFormatter.date(from: string)
        } else {
            fatalError()
        }
    }
    
    func containsError() -> Bool {
        return errorMessage() != nil
    }
    
    func errorMessage() -> String? {
        return string(for: ":error")
    }
}
