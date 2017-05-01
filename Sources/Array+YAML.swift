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

internal extension Array where Iterator.Element == String {
    func dict() -> [String: AnyObject] {
        var result = [String: AnyObject]()
        
        for line in self {
            guard let range = line.range(of: ": ") else {
                continue
            }
            
            let key = line.substring(to: range.lowerBound).trimmingCharacters(in: .whitespaces)
            var value: AnyObject
            let string = line.substring(from: range.upperBound)
            if string == "[]" {
                value = [] as AnyObject
            } else {
                value = string as AnyObject
            }
            
            result[key] = value
        }
        
        return result
    }
    
    func sections() -> [[String]] {
        var result = [[String]]()
        
        var working: [String]? = nil
        
        let indent = self.first!.characters.prefix(while: { $0 == " " }).count
        
        let processed = self.map({ $0.substring(from: $0.index($0.startIndex, offsetBy: indent)) })
        
        for line in processed {
            if line.hasPrefix(DictMarker) {
                if let previous = working {
                    result.append(previous)
                }
                
                working = []
                
                //remove the marker from key
                let modified = line.replacingOccurrences(of: DictMarker, with: "  ")
                working?.append(modified)
            } else {
                working?.append(line)
            }
        }
        
        if let previous = working {
            result.append(previous)
        }
        
        return result
    }
    
    typealias  ExtractedSub = (sub: [String: AnyObject], remaining: [String])
    func extractSubItem() -> (ExtractedSub) {
        guard let subStartIndex = self.index(where: { $0.trimmingCharacters(in: .whitespaces).hasPrefix(DictMarker) }) else {
            return ([:], self)
        }
        
        let subKeyIndex = subStartIndex.advanced(by: -1)
        let indent = String(self[subKeyIndex].characters.prefix(while: { $0 == " " }))
        var subEndIndex = subKeyIndex

        let subStartMarker = "\(indent)- "
        let subLineMarker = "\(indent)  "
        
        let afterKey = self.suffix(from: subStartIndex)
        for line in afterKey {
            if line.hasPrefix(subStartMarker) || line.hasPrefix(subLineMarker) {
                subEndIndex = subEndIndex.advanced(by: 1)
                
                continue
            }
            break
        }
        
        var remaining = Array(self)
        remaining.removeSubrange(subKeyIndex...subEndIndex)
        
        let subLines = Array(self[subKeyIndex...subEndIndex]).sections()
        let key = self[subKeyIndex].trimmingCharacters(in: CharacterSet(charactersIn: " :"))
        let sub = [key: subLines.map({ $0.dict() }) as AnyObject]
        
        return (sub, remaining)
    }
    
    func containsSubItems() -> Bool {
        guard let firstLine = first else {
            return false
        }
        
        let indent = String(firstLine.characters.prefix(while: { $0 == " " }))
        let prefix = "\(indent)\(DictMarker)"
        for line in self {
            if line.hasPrefix(prefix) {
                return true
            }
        }
        return false
    }
}
