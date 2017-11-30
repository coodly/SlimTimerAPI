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

public struct Entry {
    public let id: Int?
    public let startTime: Date
    public let endTime: Date?
    public let taskId: Int
    public let tags: [String]?
    public let comment: String?
    public let durationInSeconds: Int
    public let inProgress: Bool
}

public extension Entry {
    public init(id: Int?, startTime: Date, endTime: Date?, taskId: Int, tags: [String]?, comment: String?) {
        self.id = id
        self.startTime = startTime
        self.endTime = endTime
        self.taskId = taskId
        self.tags = tags
        self.comment = comment
        self.inProgress = endTime == nil
        
        let end = endTime ?? Date()
        durationInSeconds = Int(end.timeIntervalSince(startTime))
    }
}

extension Entry: RequestBody {
    
}
