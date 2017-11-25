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

public class Authenticator {
    private let apiKey: String
    private let fetch: NetworkFetch
    public init(key: String, fetch: NetworkFetch) {
        self.apiKey = key
        self.fetch = fetch
    }
    
    public func authenticate(_ email: String, password: String, completion: @escaping ((LoginResult) -> ())) {
        Logging.log("Perform login")
        
        let request = LoginRequest(email: email, password: password)
        request.resultHandler = completion
        request.apiKey = apiKey
        request.fetch = fetch
        request.execute()
    }
}
