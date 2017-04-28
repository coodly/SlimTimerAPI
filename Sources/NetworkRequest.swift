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

private enum Method: String {
    case POST
    case GET
}

private typealias Dependencies = FetchConsumer

internal class NetworkRequest: Dependencies {
    var fetch: NetworkFetch!
    
    final func execute() {
        performRequest()
    }

    func POST(_ path: String, parameters: [String: AnyObject]? = nil) {
        executeMethod(.POST, path: path, parameters: parameters)
    }
    
    private func executeMethod(_ method: Method, path: String, parameters: [String: AnyObject]?) {
        
    }
    
    func performRequest() {
        fatalError("Override \(#function)")
    }
}
