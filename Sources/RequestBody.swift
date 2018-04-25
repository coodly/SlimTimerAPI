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

private let Heading = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
private let Normalizations = [
    "apiKey": "api-key",
    "entry": "time-entry",
    "inProgress": "in-progress",
    "durationInSeconds": "duration-in-seconds",
    "taskId": "task-id",
    "endTime": "end-time",
    "startTime": "start-time",
    "completedOn": "completed_on"
]
private let Filtered = ["id", "updatedAt", "createdAt"]

private extension DateFormatter {
    static let xmlDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        return formatter
    }()
}

internal struct XmlNode {
    let name: String
    let value: AnyObject
    
    func lines() -> [String] {
        var result = [String]()
        result.append("<\(name)>")
        
        if let string = value as? String {
            result.append(string)
        } else if let nodes = value as? [XmlNode] {
            for node in nodes {
                result.append(contentsOf: node.lines())
            }
        }
        
        result.append("</\(name)>")
        return result
    }
}

internal protocol RequestBody {
    func asNodes() -> [XmlNode]
}

internal extension RequestBody {
    func asNodes() -> [XmlNode] {
        let mirror = Mirror(reflecting: self)
        
        var result = [XmlNode]()
        
        for child in mirror.children {            
            guard let name = child.label else {
                continue
            }
            
            if Filtered.contains(name) {
                continue
            }
            
            let normalized = Normalizations[name] ?? name
            let value: AnyObject
            if let body = child.value as? RequestBody {
                value = body.asNodes() as AnyObject
            } else if let string = child.value as? String, string.hasValue() {
                value = string as AnyObject
            } else if let bool = child.value as? Bool {
                value = (bool ? "true" : "false") as AnyObject
            } else if let number = child.value as? Int {
                value = String(describing: number) as AnyObject
            } else if let date = child.value as? Date {
                value = DateFormatter.xmlDateFormatter.string(from: date) as AnyObject
            } else if let tags = child.value as? [String] {
                value = tags.sorted().joined(separator: ",") as AnyObject
            } else {
                continue
            }
            
            
            result.append(XmlNode(name: normalized, value: value))
        }
        
        return result.sorted(by: { $0.name < $1.name })
    }
    
    func generate() -> String {
        var lines = [Heading]
        
        let request = XmlNode(name: "request", value: asNodes() as AnyObject)
        lines.append(contentsOf: request.lines())
        
        return lines.joined()
    }
}
