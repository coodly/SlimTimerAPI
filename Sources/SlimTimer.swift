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

public class SlimTimer: InjectionHandler {
    public var isLoggedIn: Bool {
        let credentials = Injector.injector.credentials
        return credentials?.accessToken != nil && credentials?.userId != nil
    }
    
    public init(key: String, credentials: CredentialsSource, fetch: NetworkFetch) {
        Injector.injector.apiKey = key
        Injector.injector.credentials = credentials
        Injector.injector.fetch = fetch
    }
}

public extension SlimTimer { // MARK: authenticate
    public func authenticate(_ email: String, password: String, completion: @escaping ((LoginResult) -> ())) {
        Logging.log("Perform login")
        
        let request = LoginRequest(email: email, password: password)
        request.resultHandler = completion
        inject(into: request)
        request.execute()
    }
}

public extension SlimTimer { // MARK: tasks
    public func fetchTasks() {
        Logging.log("Fetch tasks")
        
        let request = ListTasksRequest()
        inject(into: request)
        request.execute()
    }
}
