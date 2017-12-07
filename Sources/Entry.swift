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

public struct Entry {
    public let id: Int?
    public let startTime: Date
    public let endTime: Date?
    public let taskId: Int
    public let tags: [String]?
    public let comments: String?
    public let durationInSeconds: Int
    public let inProgress: Bool
    public let task: Task?
    public let updatedAt: Date?
}

public extension Entry {
    public init(id: Int?, startTime: Date, endTime: Date?, taskId: Int, tags: [String]?, comments: String?) {
        self.id = id
        self.startTime = startTime
        self.endTime = endTime
        self.taskId = taskId
        self.tags = tags
        self.comments = comments
        self.inProgress = endTime == nil
        task = nil
        updatedAt = nil
        
        let end = endTime ?? Date()
        durationInSeconds = max(Int(end.timeIntervalSince(startTime)), 60)
    }
}

extension Entry: RequestBody {
    
}

extension Entry: RemoteModel {
    init?(xml: XMLIndexer) {
        //TODO jaanus: figure this out
        let entry: XMLIndexer
        switch xml["time-entry"] {
        case .xmlError(_):
            entry = xml
        default:
            entry = xml["time-entry"]
        }
        
        guard let idString = entry["id"].element?.text, let id = Int(idString) else {
            return nil
        }
        
        guard let start = entry["start-time"].element?.date else {
            return nil
        }
        
        let taskData = entry["task"]
        guard let task = Task(xml: taskData) else {
            return nil
        }
        
        self.id = id
        self.startTime = start
        self.task = task
        self.taskId = task.id
        
        tags = (entry["tags"].element?.text ?? "").components(separatedBy: ",")
        comments = entry["comments"].element?.text ?? ""

        inProgress = entry["in-progress"].element?.bool ?? false

        let endTime = entry["end-time"].element?.date

        let end = endTime ?? Date()
        durationInSeconds = Int(end.timeIntervalSince(start))
        
        updatedAt = entry["updated-at"].element?.date
        
        if inProgress {
            self.endTime = nil
        } else {
            self.endTime = endTime
        }
    }
}
