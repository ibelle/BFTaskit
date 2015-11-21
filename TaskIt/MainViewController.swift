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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    //UITableview data source
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return fetchedResultsController.sections![section].numberOfObjects
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let task = fetchedResultsController.objectAtIndexPath(indexPath) as! Task
        print(task)
        let cell:TaskTableViewCell =  tableView.dequeueReusableCellWithIdentifier("myCell") as! TaskTableViewCell
        cell.dateLabel.text = dateFormatter.stringFromDate(task.date!)
        cell.taskLabel.text = task.mainTask
        cell.subTaskLabel.text = task.subTask
    
        return cell
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showTaskDetail" {
            let detailVC: TaskDetailViewController = segue.destinationViewController as! TaskDetailViewController
            let indexPath = self.tableView.indexPathForSelectedRow
            let thisTask = fetchedResultsController.objectAtIndexPath(indexPath!) as! Task
            detailVC.detailTask = thisTask
        }
    }
    
    @IBAction func addButtonTapped(sender: UIBarButtonItem) {
        self.performSegueWithIdentifier("showTaskAdd", sender: self)
    }
    
    //UITableView Delegate
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return fetchedResultsController.sections!.count
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print(indexPath.row)
        performSegueWithIdentifier("showTaskDetail", sender: self)
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if fetchedResultsController.sections?.count == 1 {
            let task = fetchedResultsController.fetchedObjects![0] as! Task
            return task.completed!.boolValue ? "Completed" : "To-Do"
        }
        return section == 0 ? "To-Do" : "Completed"
    }
    
    func tableView(tableView: UITableView, titleForDeleteConfirmationButtonForRowAtIndexPath indexPath: NSIndexPath) -> String? {
        if fetchedResultsController.sections?.count == 1 {
            let task = fetchedResultsController.fetchedObjects![0] as! Task
            return task.completed!.boolValue ? "Re-Open" : "End"
        }
        return indexPath.section == 0 ?  "End" : "Re-Open"
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        let thisTask = fetchedResultsController.objectAtIndexPath(indexPath) as! Task
        
        if !thisTask.completed!.boolValue  {
            thisTask.completed = true
        }else {
            thisTask.completed = false
        }
        
        (UIApplication.sharedApplication().delegate as! AppDelegate).saveContext()
        
    }

   

    //Misc
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.reloadData()
    }
    
    func taskFetchRequest () -> NSFetchRequest {
        let request = NSFetchRequest(entityName: "Task")
        let sortDisc:NSSortDescriptor = NSSortDescriptor(key: "date", ascending: true)
        let completedDescriptor:NSSortDescriptor = NSSortDescriptor(key: "completed", ascending: true)
        request.sortDescriptors = [completedDescriptor,sortDisc]
        
        return request
    }
    
    func getFetchedResultsController() -> NSFetchedResultsController {
       let fetchedResultsController = NSFetchedResultsController(fetchRequest: self.taskFetchRequest(),
        managedObjectContext: self.managedObjectContext!, sectionNameKeyPath: "completed", cacheName: nil)
     return fetchedResultsController
    }

}

