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

private let DocumentStartMarker = "---"

internal struct YAMLResponse {
    let data: Data
    
    func parse() -> AnyObject? {
        guard let string = String(data: data, encoding: .utf8) else {
            return nil
        }
        
        var result = [String: AnyObject]()
        
        let lines = string.components(separatedBy: .newlines)
        for line in lines {
            if line == DocumentStartMarker {
                continue
            }
            
            guard let range = line.range(of: ": ") else {
                continue
            }
            
            let key = line.substring(to: range.lowerBound)
            let value = line.substring(from: range.upperBound)
            
            result[key] = value as AnyObject
        }
        
        return result as AnyObject
    }
}
