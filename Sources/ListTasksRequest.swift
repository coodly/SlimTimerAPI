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

private let ListTasksPathBase = "/users/%@/tasks"

internal class ListTasksRequest: NetworkRequest<RemoteTask>, AuthenticatedRequest {
    override func performRequest() {
        let path = String(format: ListTasksPathBase, NSNumber(value: credentials.userId!))
        
        GET(path)
    }
    
    override func handle(result: NetworkResult<RemoteTask>) {
        dump(result)
    }
}

internal struct RemoteTask: RemoteModel {
    init?(yaml: AnyObject) {
        
    }
}
