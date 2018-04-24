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
import SWXMLHash

public struct Task {
    public let name: String
    public let createdAt: Date
    public let completedOn: Date?
    public let updatedAt: Date
    public let tags: [String]
    public let id: Int?
    public let hours: Double
}

public extension Task {
    public init(id: Int?, name: String, createdAt: Date, completedOn: Date?, tags: [String]) {
        self.id = id
        self.name = name
        self.createdAt = createdAt
        self.completedOn = completedOn
        self.tags = tags
        self.updatedAt = Date()
        self.hours = 0
    }
}

extension Task: RemoteModel {
    init?(xml: XMLIndexer) {
        //TODO jaanus: figure this out
        let task: XMLIndexer
        switch xml["task"] {
        case .xmlError(_):
            task = xml
        default:
            task = xml["task"]
        }
        
        guard let name = task["name"].element?.text else {
            return nil
        }
        
        guard let createdAt = task["created-at"].element?.date else {
            return nil
        }

        completedOn = task["completed-on"].element?.date
        
        guard let updatedAt = task["updated-at"].element?.date else {
            return nil
        }
        
        let tagsString = task["tags"].element?.text ?? ""
        tags = tagsString.components(separatedBy: ",")
        
        guard let idString = task["id"].element?.text, let id = Int(idString) else {
            return nil
        }
        
        hours = task["hours"].element?.double ?? 0
        
        self.name = name
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.id = id
    }
}

