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


private extension DateFormatter {
    static let xmlDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        return formatter
    }()
}

internal extension SWXMLHash.XMLElement {
    var date: Date? {
        return DateFormatter.xmlDate.date(from: text)
    }
    
    var double: Double? {
        return Double(text)
    }
    
    var bool: Bool {
        return Bool(text) ?? false
    }
    
    var int: Int? {
        return Int(text)
    }
}
