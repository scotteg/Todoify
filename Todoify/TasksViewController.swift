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

class TasksViewController : UITableViewController {
    
    @IBOutlet weak var filterButton: UIButton!
    
    var tasks: Results<Task>!
    var subscription: NotificationToken?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tasks = getTasks(done: false)
        subscription = notificationSubscription(tasks: tasks)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    @IBAction func toggleFilter(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        tasks = getTasks(done: sender.isSelected)
        subscription = notificationSubscription(tasks: tasks)
        tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
    }
        
    func getTasks(done: Bool) -> Results<Task> {
        let realm = try! Realm()
        tasks = realm.objects(Task.self)
        
        if done {
            tasks = tasks.filter("done = true")
        }
        
        return tasks.sorted(by: [
            SortDescriptor(property: "priority", ascending: false),
            SortDescriptor(property: "created", ascending: false)
            ])
    }
    
    func notificationSubscription(tasks: Results<Task>) -> NotificationToken {
        return tasks.addNotificationBlock { [weak self] (changes: RealmCollectionChange<Results<Task>>) in
            guard let `self` = self else { return }
            self.updateUI(changes: changes)
        }
    }
    
    func updateUI(changes: RealmCollectionChange<Results<Task>>) {
        switch changes {
        case .initial(_):
            tableView.reloadData()
        case let .update(_, deletions, insertions, _):
            tableView.beginUpdates()
            
            tableView.insertRows(at: insertions.map {
                IndexPath(row: $0, section: 0)
            }, with: .automatic)
            
            tableView.deleteRows(at: deletions.map {
                IndexPath(row: $0, section: 0)
            }, with: .automatic)
            
            tableView.endUpdates()
        case .error(let error):
            print(error)
        }
    }
    
    //MARK: - Table methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let task = tasks[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell") as! TaskCell
        cell.configureCellWith(task: task)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            try! tasks.realm!.write { // Ok to reuse realm on same thread it was created
                let task = tasks[indexPath.row]
                tasks.realm!.delete(task)
            }
            
//            tableView.deleteRows(at: [indexPath], with: .fade) // Handled by notification
        }
    }
    
}
