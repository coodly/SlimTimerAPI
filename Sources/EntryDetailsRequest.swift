/*
 * Copyright 2018 Coodly LLC
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

private let EntryDetailsPathBase = "/users/%@/time_entries/%@"

public enum EntryDetailsResult {
    case success(Entry)
    case failure(Error)
}

internal class EntryDetailsRequest: NetworkRequest<Entry>, UserIdConsumer, AuthenticatedRequest {
    var userId: Int!
    
    internal var resultHandler: ((EntryDetailsResult) -> Void)?
    
    private let entryId: Int
    init(entryId: Int) {
        self.entryId = entryId
    }
    
    override func performRequest() {
        let path = String(format: EntryDetailsPathBase, NSNumber(value: userId), NSNumber(value: entryId))
        GET(path)
    }
    
    override func handle(result: NetworkResult<Entry>) {
        if let value = result.value {
            resultHandler?(.success(value))
        } else {
            resultHandler?(.failure(result.error ?? .unknown))
        }
    }
}
