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

private enum Method: String {
    case POST
    case GET
}


private let ServerAPIURLString = "http://slimtimer.com"

private typealias Dependencies = FetchConsumer

internal class NetworkRequest: Dependencies, InjectionHandler {
    var fetch: NetworkFetch!
    
    final func execute() {
        performRequest()
    }

    func POST(_ path: String, body: RequestBody) {
        executeMethod(.POST, path: path, body: body)
    }
    
    private func executeMethod(_ method: Method, path: String, body: RequestBody?) {
        inject(into: body as AnyObject)
        
        var components = URLComponents(url: URL(string: ServerAPIURLString)!, resolvingAgainstBaseURL: true)!
        components.path = components.path + path
        
        let requestURL = components.url!
        let request = NSMutableURLRequest(url: requestURL)
        request.httpMethod = method.rawValue
        
        Logging.log("\(method) to \(requestURL.absoluteString)")

        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        if let data = body?.generate().data(using: .utf8) {
            request.httpBody = data
            request.addValue("application/xml", forHTTPHeaderField: "Content-Type")
        }
        
        fetch.fetch(request: request as URLRequest) {
            data, response, error in
            
            if let data = data {
                Logging.log("Response: \(String(data: data, encoding: .utf8) ?? "-")")
                
            } else if let error = error {
                self.handle(error: error)
            } else {
                fatalError()
            }
        }
    }
    
    func handle(error: Error) {
        Logging.log("Handle error \(error)")
    }
    
    func performRequest() {
        fatalError("Override \(#function)")
    }
}
