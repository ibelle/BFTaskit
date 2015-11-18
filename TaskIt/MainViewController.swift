//
//  ViewController.swift
//  TaskIt
//
//  Created by Isaiah Belle on 10/4/15.
//  Copyright © 2015 Isaiah Belle. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var taskDict:[String:[Task]]=[:]
    let dateFormatter:NSDateFormatter = NSDateFormatter()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        // Do any additional setup after loading the view, typically from a nib.
        let task1 = Task(mainTask: "I Get Money", subTask: "Money I Got", date: dateFormatter.dateFromString("11/16/2015")!, completed:false)
        let task2 = Task(mainTask: "Gimme Tha Loot", subTask: "I'm a BadBoy", date: dateFormatter.dateFromString("10/18/2015")!, completed:false)
        let task3 = Task(mainTask: "Make It Rain", subTask: "Rain on dees #0es", date:dateFormatter.dateFromString("07/19/2015")!, completed:false)
        taskDict["incomplete"]=[task1,task2,task3]
        taskDict["complete"]=[Task(mainTask: "Code this Project", subTask: "in Swift 2.1", date:dateFormatter.dateFromString("11/15/2015")!, completed:true)
]
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        taskDict["incomplete"]!.sortInPlace({(taskOne:Task, taskTwo:Task) -> Bool in return taskOne.date.timeIntervalSince1970 < taskTwo.date.timeIntervalSince1970})
        self.tableView.reloadData()
    }
    
    //UITableview data source
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskDict["incomplete"]!.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        print(indexPath.row)
        
        let task = taskDict["incomplete"]![indexPath.row]
        
        let cell:TaskTableViewCell =  tableView.dequeueReusableCellWithIdentifier("myCell") as! TaskTableViewCell
        cell.dateLabel.text = dateFormatter.stringFromDate(task.date)
        cell.taskLabel.text = task.maintask
        cell.subTaskLabel.text = task.subtask
        
        return cell
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showTaskDetail" {
            let detailVC: TaskDetailViewController = segue.destinationViewController as! TaskDetailViewController
            let indexPath = self.tableView.indexPathForSelectedRow
            let thisTask = taskDict["incomplete"]![indexPath!.row]
            detailVC.detailTask = thisTask
            detailVC.mainVC = self
        }else if segue.identifier == "showTaskAdd" {
             let addTaskVC: AddTaskViewController = segue.destinationViewController as! AddTaskViewController
            addTaskVC.mainVC = self
        }
    }
    //UITableView Delegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //
        print(indexPath.row)
        
        performSegueWithIdentifier("showTaskDetail", sender: self)
    }

    @IBAction func addButtonTapped(sender: UIBarButtonItem) {
        self.performSegueWithIdentifier("showTaskAdd", sender: self)
    }


}

