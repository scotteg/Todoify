/*
 * Copyright (c) 2016 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import Foundation
import RealmSwift

class Task : Object {
    
    dynamic var taskId = NSUUID().uuidString
    
    dynamic var title = ""
    dynamic var done = false
    dynamic var created = Date()
    dynamic var priority = 0
    
    convenience init(title: String, priority: Int) {
        self.init()
        self.title = title
        self.priority = priority
    }
    
    // Realm metadata
    override static func primaryKey() -> String? {
        return "taskId"
    }
    
    override static func indexedProperties() -> [String] {
        return ["done"]
    }
    
    override static func ignoredProperties() -> [String] {
        return []
    }
    
}

extension Task {
    
    var priorityText: String {
        return priority > 0 ? "High" : "Default"
    }
    
    var priorityColor: UIColor {
        return priority > 0 ? UIColor.red : UIColor.blue
    }
    
}
