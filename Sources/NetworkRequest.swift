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


public enum SlimTimerError: Error {
    case noData
    case network(Error)
    case server(String)
    case unknown
}

internal struct NetworkResult<T: RemoteModel> {
    var value: T? {
        return values?.first
    }
    
    let values: [T]?
    let error: SlimTimerError?
}

private let ServerAPIURLString = "http://slimtimer.com"

private typealias Dependencies = FetchConsumer & CredentialsConsumer

internal class NetworkRequest<Model: RemoteModel>: Dependencies, InjectionHandler, APIKeyConsumer {
    var fetch: NetworkFetch!
    var credentials: CredentialsSource!
    var apiKey: String!
    
    final func execute() {
        performRequest()
    }

    func GET(_ path: String) {
        executeMethod(.GET, path: path, body: nil)
    }

    func POST(_ path: String, body: RequestBody) {
        executeMethod(.POST, path: path, body: body)
    }
    
    private func executeMethod(_ method: Method, path: String, body: RequestBody?) {
        inject(into: body as AnyObject)
        
        var components = URLComponents(url: URL(string: ServerAPIURLString)!, resolvingAgainstBaseURL: true)!
        components.path = components.path + path
        
        if self is AuthenticatedRequest {
            var queryItems = [URLQueryItem]()
            
            queryItems.append(URLQueryItem(name: "api_key", value: apiKey))
            queryItems.append(URLQueryItem(name: "access_token", value: credentials.accessToken!))
            
            components.queryItems = queryItems
        }
        
        let requestURL = components.url!
        let request = NSMutableURLRequest(url: requestURL)
        request.httpMethod = method.rawValue
        
        Logging.log("\(method) to \(requestURL.absoluteString)")

        request.addValue("application/x-yaml", forHTTPHeaderField: "Accept")
        
        if let data = body?.generate().data(using: .utf8) {
            request.httpBody = data
            request.addValue("application/xml", forHTTPHeaderField: "Content-Type")
        }
        
        fetch.fetch(request: request as URLRequest) {
            data, response, networkError in
            
            if let data = data, let string = String(data: data, encoding: .utf8) {
                Logging.log("Response:\n\(string)")
            }
            
            var values: [Model]?
            var error: SlimTimerError?
            
            defer {
                self.handle(result: NetworkResult(values: values, error: error))
            }
            
            if let remoteError = networkError  {
                error = .network(remoteError)
                return
            }
            
            guard let data = data, let body = YAMLResponse(data: data).parse() else {
                error = .noData
                return
            }
            
            if let dict = body as? [String: AnyObject], let errorMessage = dict.errorMessage() {
                error = .server(errorMessage)
                return
            }
            
            if let dict = body as? [String: AnyObject], let value = Model(yaml: dict as AnyObject) {
                values = [value]
            } else if let array = body as? [[String: AnyObject]] {
                values = array.flatMap({ Model(yaml: $0 as AnyObject) })
            } else {
                error = .noData
            }
        }
    }
    
    func handle(result: NetworkResult<Model>) {
        Logging.log("Handle \(result)")
    }
    
    func performRequest() {
        fatalError("Override \(#function)")
    }
}
