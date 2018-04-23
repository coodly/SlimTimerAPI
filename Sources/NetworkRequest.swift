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
import SWXMLHash

internal enum Method: String {
    case POST
    case GET
    case PUT
    case DELETE
}

public enum SlimTimerError: Error {
    case noData
    case network(Error)
    case server(String)
    case unknown
}

internal struct NetworkResult<T: RemoteModel> {
    var value: T?
    let statusCode: Int
    let error: SlimTimerError?
}

private extension DateFormatter {
    static let paramDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter
    }()
}

private let ServerAPIURLString = "http://slimtimer.com"

private typealias Dependencies = FetchConsumer & AccessTokenConsumer & APIKeyConsumer

internal class NetworkRequest<Model: RemoteModel>: Dependencies {
    var fetch: NetworkFetch!
    var apiKey: String!
    var accessToken: String!
    
    final func execute() {
        performRequest()
    }

    func GET(_ path: String, params: [String: AnyObject]? = nil) {
        executeMethod(.GET, path: path, body: nil, params: params)
    }

    func POST(_ path: String, body: RequestBody) {
        executeMethod(.POST, path: path, body: body)
    }

    func PUT(_ path: String, body: RequestBody) {
        executeMethod(.PUT, path: path, body: body)
    }

    func DELETE(_ path: String) {
        executeMethod(.DELETE, path: path, body: nil)
    }

    internal func executeMethod(_ method: Method, path: String, body: RequestBody?, params: [String: AnyObject]? = nil) {
        if var consumer = body as? APIKeyConsumer {
            consumer.apiKey = apiKey
        }
        
        var components = URLComponents(url: URL(string: ServerAPIURLString)!, resolvingAgainstBaseURL: true)!
        components.path = components.path + path

        var queryItems = [URLQueryItem]()
        
        
        if self is AuthenticatedRequest {
            queryItems.append(URLQueryItem(name: "api_key", value: apiKey))
            queryItems.append(URLQueryItem(name: "access_token", value: accessToken))
        }
        
        for (key, value) in params ?? [:] {
            if let number = value as? Int {
                let used = String(describing: number)
                queryItems.append(URLQueryItem(name: key, value: used))
            } else if let date = value as? Date {
                let dateString = DateFormatter.paramDateFormatter.string(from: date)
                queryItems.append(URLQueryItem(name: key, value: dateString))
            } else if let string = value as? String {
                queryItems.append(URLQueryItem(name: key, value: string))
            }
        }

        components.queryItems = queryItems
        
        let requestURL = components.url!
        let request = NSMutableURLRequest(url: requestURL)
        request.httpShouldHandleCookies = false
        
        request.httpMethod = method.rawValue
        
        Logging.log("\(method) to \(requestURL.absoluteString)")

        request.addValue("application/xml", forHTTPHeaderField: "Accept")
        
        if let string = body?.generate(), let data = string.data(using: .utf8) {
            request.httpBody = data
            request.addValue("application/xml", forHTTPHeaderField: "Content-Type")
            
            Logging.log("Body\n\(string)")
        }
        
        fetch.fetch(request: request as URLRequest) {
            data, response, networkError in

            let statusCode = (response as? HTTPURLResponse)?.statusCode ?? -1
            Logging.log("Status code: \(statusCode)")
            
            if let data = data, let string = String(data: data, encoding: .utf8) {
                Logging.log("Response:\n\(string)")
            }
            
            var value: Model?
            var error: SlimTimerError?
            
            defer {
                self.handle(result: NetworkResult(value: value, statusCode: statusCode, error: error))
            }
            
            if let remoteError = networkError  {
                error = .network(remoteError)
                return
            }
            
            if Model.self is EmptySuccessResponse.Type, statusCode == 200 {
                value = EmptySuccessResponse() as? Model
                return
            }
            
            guard let data = data else {
                error = .noData
                return
            }
            
            let xml = SWXMLHash.parse(data)
            
            if let errorMessage = xml.errorMessage {
                error = .server(errorMessage)
                return
            }
            
            if let model = Model(xml: xml) {
                value = model
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
