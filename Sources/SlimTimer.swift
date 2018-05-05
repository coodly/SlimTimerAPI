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

public class SlimTimer {
    private let apiKey: String
    private let userId: Int
    private let userToken: String
    private let fetch: NetworkFetch
    
    public init(key: String, userId: Int, userToken: String, fetch: NetworkFetch) {
        self.apiKey = key
        self.userId = userId
        self.userToken = userToken
        self.fetch = fetch
    }

    private func inject(into: AnyObject) {
        if var consumer = into as? FetchConsumer {
            consumer.fetch = fetch
        }
        
        if var consumer = into as? APIKeyConsumer {
            consumer.apiKey = apiKey
        }
        
        if var consumer = into as? AccessTokenConsumer {
            consumer.accessToken = userToken
        }
        
        if var consumer = into as? UserIdConsumer {
            consumer.userId = userId
        }
    }
}

public extension SlimTimer { // MARK: tasks
    public func fetchTasks(offset: Int = 0, showCompleted: ShowCompleted = .yes, completion: @escaping ((ListTasksResult) -> Void)) {
        Logging.log("Fetch tasks")
        
        let request = ListTasksRequest(offset: offset, showCompleted: showCompleted)
        request.resultHandler = completion
        inject(into: request)
        request.execute()
    }

    public func delete(task: Task, completion: @escaping ((DeleteTaskResult) -> Void)) {
        let request = DeleteTaskRequest(task: task)
        request.resultHandler = completion
        inject(into: request)
        request.execute()
    }
    
    public func save(task: Task, completion: @escaping ((SaveTaskResult) -> Void)) {
        Logging.log("Save \(task)")
        
        let request = SaveTaskRequest(task: task)
        request.resultHandler = completion
        inject(into: request)
        request.execute()
    }
}

public extension SlimTimer { // MARK: entries
    public func save(entry: Entry, completion: @escaping ((SaveEntryResult) -> Void)) {
        Logging.log("Save \(entry)")
        
        let request = SaveEntryRequest(entry: entry)
        request.resultHandler = completion
        inject(into: request)
        request.execute()
    }
    
    @available(OSX 10.12, iOS 10, *)
    public func loadEntries(in range: DateInterval, offset: Int = 0, completion: @escaping ((ListEntriesResult) -> Void)) {
        Logging.log("Load entries in \(range)")
        
        let request = LoadEntriesRequest(interval: range, offset: offset)
        request.resultHandler = completion
        inject(into: request)
        request.execute()
    }
    
    public func delete(entry: Entry, completion: @escaping ((DeleteEntryResult) -> Void)) {
        let request = DeleteEntryRequest(entry: entry)
        request.resultHandler = completion
        inject(into: request)
        request.execute()
    }
    
    public func detailsFor(entry id: Int, completion: @escaping ((EntryDetailsResult) -> Void)) {
        let request = EntryDetailsRequest(entryId: id)
        request.resultHandler = completion
        inject(into: request)
        request.execute()
    }
}
