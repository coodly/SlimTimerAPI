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

private let DeleteEntryPathBase = "/users/%@/time_entries/%@"

public enum DeleteEntryResult {
    case success
    case failure(Error)
}

internal class DeleteEntryRequest: NetworkRequest<EmptySuccessResponse>, UserIdConsumer, AuthenticatedRequest {
    var userId: Int!
    
    internal var resultHandler: ((DeleteEntryResult) -> Void)?
    
    private let entry: Entry
    init(entry: Entry) {
        self.entry = entry
    }
    
    override func performRequest() {
        guard let entryId = entry.id else {
            Logging.log("Trying to delete entry that was not created remotely. Just report that it's deleted")
            resultHandler?(.success)
            return
        }
        
        let path = String(format: DeleteEntryPathBase, NSNumber(value: userId), NSNumber(value: entryId))
        DELETE(path)
    }
    
    override func handle(result: NetworkResult<EmptySuccessResponse>) {
        if result.value?.success ?? false {
            resultHandler?(.success)
        } else {
            resultHandler?(.failure(result.error ?? .unknown))
        }
    }
}
