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

import UIKit
import RealmSwift

class CreateTaskViewController : UITableViewController {
    
    @IBOutlet weak var taskTitle: UITextField!
    @IBOutlet weak var taskPrio: UISegmentedControl!
    @IBOutlet weak var taskUsers: UISegmentedControl!
    
    let users: [User] = {
        let realm = try! Realm()
        return Array(realm.objects(User.self))
    }()
    
    @IBAction func createTask(_ sender: AnyObject) {
        let realm = try! Realm()
        let task = Task(title: taskTitle.text!, priority: taskPrio.selectedSegmentIndex)
        
        let user = users[taskUsers.selectedSegmentIndex]
        
        try! realm.write {
            user.tasks.append(task)
        }
        
        navigationController!.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        taskUsers.removeAllSegments()
        
        users.forEach {
            taskUsers.insertSegment(withTitle: $0.name, at: taskUsers.numberOfSegments, animated: false)
        }
        
        taskUsers.selectedSegmentIndex = 0
        taskTitle.becomeFirstResponder()
    }
    
}
