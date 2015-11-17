//
//  TaskDetailViewController.swift
//  TaskIt
//
//  Created by Isaiah Belle on 11/15/15.
//  Copyright © 2015 Isaiah Belle. All rights reserved.
//

import UIKit

class TaskDetailViewController: UIViewController {

    @IBOutlet weak var taskDetailText: UITextField!
    @IBOutlet weak var subtaskDetailText: UITextField!
    @IBOutlet weak var taskDetailDate: UIDatePicker!
   
    
    var detailTask: Task!
    var mainVC: MainViewController!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print (self.detailTask)
        
        
        self.taskDetailText.text = detailTask.maintask
        self.subtaskDetailText.text = detailTask.subtask
        self.taskDetailDate.date = detailTask.date
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
     @IBAction func cancelButtonTapped(sender: UIBarButtonItem) {
        self.navigationController?.popViewControllerAnimated(true)
    }
   
    @IBAction func doneButtonPressed(sender: UIBarButtonItem) {
        let taskUpdate:Task = Task(mainTask: self.taskDetailText.text!, subTask: self.subtaskDetailText.text!, date: self.taskDetailDate.date)
        mainVC.taskArray[mainVC.tableView.indexPathForSelectedRow!.row]=taskUpdate
        self.navigationController?.popViewControllerAnimated(true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}

