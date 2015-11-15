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
    
    var taskArray:[Task]=[]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let task1 = Task(mainTask: "I Get Money", subTask: "Money I Got", date: "11/16/2015")
        let task2 = Task(mainTask: "Gimme Tha Loot", subTask: "I'm a BadBoy", date: "11/18/2015")
        let task3 = Task(mainTask: "Make It Rain", subTask: "Rain on dees #0es", date:"11/19/2015")
        
        taskArray = [task1,task2,task3]
        self.tableView.reloadData() //NOT NEEDED
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //UITableview data source
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskArray.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        print(indexPath.row)
        
        let task = taskArray[indexPath.row]
        
        let cell:TaskTableViewCell =  tableView.dequeueReusableCellWithIdentifier("myCell") as! TaskTableViewCell
        cell.dateLabel.text = task.date
        cell.taskLabel.text = task.maintask
        cell.subTaskLabel.text = task.subtask
        
        return cell
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showTaskDetail" {
            let detailVC: TaskDetailViewController = segue.destinationViewController as! TaskDetailViewController
            let indexPath = self.tableView.indexPathForSelectedRow
            let thisTask = taskArray[indexPath!.row]
            detailVC.detailTask = thisTask

        }
    }
    //UITableView Delegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //
        print(indexPath.row)
        
        performSegueWithIdentifier("showTaskDetail", sender: self)
    }



}

