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

private let EntryPathBase = "/users/%@/time_entries"

public enum SaveEntryResult {
    case success(Entry)
    case failure(SlimTimerError)
}

internal class SaveEntryRequest: NetworkRequest<Entry>, AuthenticatedRequest, UserIdConsumer {
    var userId: Int!
    
    internal var resultHandler: ((SaveEntryResult) -> Void)!

    private let entry: Entry
    init(entry: Entry) {
        self.entry = entry
    }
    
    override func performRequest() {
        let method: Method
        let path: String
        
        if let id = entry.id, id > 0 {
            method = .PUT
            path = String(format: EntryPathBase, NSNumber(value: userId)) + "/" + String(describing: id)
        } else {
            method = .POST
            path = String(format: EntryPathBase, NSNumber(value: userId))
        }
        
        executeMethod(method, path: path, body: EntrySaveBody(entry: entry))
    }
    
    override func handle(result: NetworkResult<Entry>) {
        if let entry = result.value {
            resultHandler(.success(entry))
        } else {
            resultHandler(.failure(result.error ?? .unknown))
        }
    }
}
