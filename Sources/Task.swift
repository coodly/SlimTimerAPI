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

public struct Task {
    let name: String
    let createdAt: Date
    let completedOn: Date?
    let updatedAt: Date
    let tags: [String]
    let id: Int
    let hours: Double
}

extension Task: RemoteModel {
    init?(yaml: AnyObject) {
        guard let data = yaml as? [String: AnyObject] else {
            return nil
        }
        
        guard let name = data.string(for: "name") else {
            return nil
        }
        
        guard let createdAt = data.date(for: "created_at") else {
            return nil
        }

        completedOn = data.date(for: "completed_on")
        
        guard let updatedAt = data.date(for: "updated_at") else {
            return nil
        }
        
        let tagsString = data.string(for: "tags") ?? ""
        tags = tagsString.components(separatedBy: ",")
        
        guard let id = data.int(for: "id") else {
            return nil
        }
        
        hours = data.double(for: "hours") ?? 0
        
        self.name = name
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.id = id
    }
}
