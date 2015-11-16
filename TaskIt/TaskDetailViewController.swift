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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}

