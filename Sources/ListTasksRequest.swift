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

private let MaxTasksPerPage = 50

public enum ShowCompleted: String {
    case yes
    case no
    case only
}

public enum ListTasksResult {
    case success([Task], Bool, Int)
    case failure(SlimTimerError)
}

private let ListTasksPathBase = "/users/%@/tasks"

internal class ListTasksRequest: NetworkRequest<Tasks>, AuthenticatedRequest, UserIdConsumer {
    internal var resultHandler: ((ListTasksResult) -> Void)!
    
    var userId: Int!
    
    private let offset: Int
    private let showCompleted: ShowCompleted
    init(offset: Int, showCompleted: ShowCompleted) {
        self.offset = offset
        self.showCompleted = showCompleted
    }
    
    override func performRequest() {
        let path = String(format: ListTasksPathBase, NSNumber(value: userId))
        
        GET(path, params: ["offset": offset as AnyObject, "show_completed": showCompleted.rawValue as AnyObject])
    }
    
    override func handle(result: NetworkResult<Tasks>) {
        if let error = result.error {
            resultHandler(.failure(error))
            return
        }
        
        guard let tasks = result.value?.tasks else {
            resultHandler(.failure(.unknown))
            return
        }
        
        let hasMore = tasks.count == MaxTasksPerPage
        resultHandler(.success(tasks, hasMore, hasMore ? offset + MaxTasksPerPage : 0))
    }
}
