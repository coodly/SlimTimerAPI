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

internal let DocumentStartMarker = "---"
internal let DictMarker = "- "

internal struct YAMLResponse {
    let data: Data
    
    func parse() -> AnyObject? {
        guard let string = String(data: data, encoding: .utf8) else {
            return nil
        }
        
        let lines = Array(string.components(separatedBy: .newlines)).filter({ $0.characters.count > 0 })
        guard lines.count > 0 else {
            Logging.log("No line in YAML response")
            return nil
        }

        let first = lines[0]
        guard first.hasPrefix(DocumentStartMarker) else {
            Logging.log("Did not start with YAML marker")
            return nil
        }
        
        let content = Array(lines.suffix(from: 1))

        guard content.count > 0 else {
            Logging.log("No content lines")
            return nil
        }
        
        guard let firstLine = content.first, firstLine.hasPrefix(DictMarker) else {
            return content.dict() as AnyObject
        }
        
        var result = [[String: AnyObject]]()
        let sections = content.sections()
        
        for section in sections {
            var sectionValues = [String: AnyObject]()
            
            var processed = section
            while processed.containsSubItems() {
                let sub = processed.extractSubItem()
                
                for (key, value) in sub.sub {
                    sectionValues[key] = value
                }
                
                processed = sub.remaining
            }
            
            let remaining = processed.dict()
            for (key, value) in remaining {
                sectionValues[key] = value
            }
            result.append(sectionValues)
        }
        
        return result as AnyObject
    }
}
