//
//  ViewController.swift
//  TaskIt
//
//  Created by Isaiah Belle on 10/4/15.
//  Copyright © 2015 Isaiah Belle. All rights reserved.
//

import UIKit
import CoreData

class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    //var taskDict:[String:[Task]]=[:]
    let dateFormatter:NSDateFormatter = NSDateFormatter()
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    var fetchedResultsController: NSFetchedResultsController = NSFetchedResultsController()
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        // Do any additional setup after loading the view, typically from a nib.
        self.fetchedResultsController = getFetchedResultsController()
        fetchedResultsController.delegate = self
        
        do{
        try fetchedResultsController.performFetch()
        }catch{
            var dict = [String: AnyObject]()
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
    
        }
        
        //self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
       
        self.tableView.reloadData()
    }
    
    //UITableview data source
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return taskDict[getStringSection(forIndex: section)]!.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        print(indexPath.row)
        
        let task = taskDict[getStringSection(forIndex: indexPath.section)]![indexPath.row]
        
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
            let thisTask = taskDict[getStringSection(forIndex: indexPath!.section)]![indexPath!.row]
            detailVC.detailTask = thisTask
            detailVC.mainVC = self
        }else if segue.identifier == "showTaskAdd" {
             let addTaskVC: AddTaskViewController = segue.destinationViewController as! AddTaskViewController
            addTaskVC.mainVC = self
        }
    }
    //UITableView Delegate
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return taskDict.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //
        print(indexPath.row)
        
        performSegueWithIdentifier("showTaskDetail", sender: self)
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25
    }
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "TODO"
        }else {
            return "COMPLETED"
        }
    }
    func tableView(tableView: UITableView, titleForDeleteConfirmationButtonForRowAtIndexPath indexPath: NSIndexPath) -> String? {
        let taskGroup = getStringSection(forIndex: indexPath.section)
        
        if taskGroup == "incomplete" {
           return "Finish"
        }else {
            return "Re-Open"
        }
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        let taskGroup = getStringSection(forIndex: indexPath.section)
        let thisTask = taskDict[taskGroup]![indexPath.row]
        
        if taskGroup == "incomplete" {
            var newTask:Task = thisTask
            newTask.isCompleted=true
            taskDict[taskGroup]!.removeAtIndex(indexPath.row)
            taskDict["complete"]?.append(newTask)
        }else if taskGroup == "complete" {
            var newTask:Task = thisTask
            newTask.isCompleted=false
            taskDict[taskGroup]!.removeAtIndex(indexPath.row)
            taskDict["incomplete"]?.append(newTask)
        }
        taskDict["incomplete"]!.sortInPlace({(taskOne:Task, taskTwo:Task) -> Bool in return taskOne.date.timeIntervalSince1970 < taskTwo.date.timeIntervalSince1970})
        taskDict["complete"]!.sortInPlace({(taskOne:Task, taskTwo:Task) -> Bool in return taskOne.date.timeIntervalSince1970 < taskTwo.date.timeIntervalSince1970})

        tableView.reloadData()
    }

    @IBAction func addButtonTapped(sender: UIBarButtonItem) {
        self.performSegueWithIdentifier("showTaskAdd", sender: self)
    }

    //Misc
    func getStringSection(forIndex forIndex:Int)-> String{
        if forIndex == 0 {
            return "incomplete"
        }else {
           return "complete"
        }
    }
    
    func taskFetchRequest () -> NSFetchRequest {
        let request = NSFetchRequest(entityName: "Task")
        let sortDisc:NSSortDescriptor = NSSortDescriptor(key: "date", ascending: true)
        request.sortDescriptors = [sortDisc]
        
        return request
    }
    
    func getFetchedResultsController() -> NSFetchedResultsController {
       let fetchedResultsController = NSFetchedResultsController(fetchRequest: self.taskFetchRequest(), managedObjectContext: self.managedObjectContext!, sectionNameKeyPath: nil, cacheName: nil)
     return fetchedResultsController
    }

}

