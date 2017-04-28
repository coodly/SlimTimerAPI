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

private let LoginPath = "/users/token"

internal class LoginRequest: NetworkRequest {
    private let email: String
    private let password: String
    
    init(email: String, password: String) {
        self.email = email
        self.password = password
    }
    
    override func performRequest() {
        POST(LoginPath, body: LoginRequestBody(email: email, password: password))
    }
}

private typealias Dependencies = APIKeyConsumer

internal class LoginRequestBody: RequestBody, Dependencies {
    var apiKey: String!
    
    private let user: User
    init(email: String, password: String) {
        user = User(email: email, password: password)
    }
}

internal struct LoginResponse: RemoteModel {
    init?(data: Data) {
        
    }
}
