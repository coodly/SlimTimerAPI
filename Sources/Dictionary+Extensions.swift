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

extension Dictionary {
    func string(for key: String) -> String? {
        let dict = self as NSDictionary
        return dict[key] as? String
    }
    
    func int(for key: String) -> Int? {
        let dict = self as NSDictionary
        let value = dict[key]
        
        if let number = value as? Int {
            return number
        }
        
        if let string = value as? String, let number = Int(string) {
            return number
        }
        
        return nil
    }
    
    func containsError() -> Bool {
        return errorMessage() != nil
    }
    
    func errorMessage() -> String? {
        return string(for: ":error")
    }
}
