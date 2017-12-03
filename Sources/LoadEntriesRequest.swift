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

private let ListEntriesPathBase = "/users/%@/time_entries"

private let EntriesPageSize = 5000

public enum ListEntriesResult {
    case success([Entry], Bool, Int)
    case failure(SlimTimerError)
}

@available(OSX 10.12, iOS 10, *)
internal class LoadEntriesRequest: NetworkRequest<Entries>, AuthenticatedRequest, UserIdConsumer {
    var userId: Int!
    
    internal var resultHandler: ((ListEntriesResult) -> Void)!

    private let interval: DateInterval
    private let offset: Int
    init(interval: DateInterval, offset: Int) {
        self.interval = interval
        self.offset = offset
    }
    
    override func performRequest() {
        let path = String(format: ListEntriesPathBase, NSNumber(value: userId))
        GET(path, params: ["range_start": interval.start as AnyObject, "range_end": interval.end as AnyObject, "offset": offset as AnyObject])
    }
    
    override func handle(result: NetworkResult<Entries>) {
        guard let entries = result.value?.entries else {
            resultHandler(.failure(result.error ?? .unknown))
            return
        }
        
        let hasMore = entries.count == EntriesPageSize
        resultHandler(.success(entries, hasMore, hasMore ? offset + EntriesPageSize : 0))
    }
}
