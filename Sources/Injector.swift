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

internal class Injector {
    var credentials: CredentialsSource!
    var apiKey: String!
    var fetch: NetworkFetch!
    
    static let injector = Injector()
    
    func inject(into: AnyObject) {
        if var consumer = into as? FetchConsumer {
            consumer.fetch = fetch
        }
        
        if var consumer = into as? APIKeyConsumer {
            consumer.apiKey = apiKey
        }
        
        if var consumer = into as? CredentialsConsumer {
            consumer.credentials = credentials
        }
    }
}

internal protocol InjectionHandler {
    func inject(into: AnyObject)
}

internal extension InjectionHandler {
    func inject(into: AnyObject) {
        Injector.injector.inject(into: into)
    }
}
