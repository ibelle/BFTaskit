//
//  Task.swift
//  TaskIt
//
//  Created by Isaiah Belle on 11/15/15.
//  Copyright © 2015 Isaiah Belle. All rights reserved.
//

import UIKit

struct Task : CustomStringConvertible{
    var maintask:String = ""
    var subtask:String = ""
    var date:String = ""
    var description: String {
        return "Task:\(maintask)::SubTask=\(subtask)::Date= \(date)"
    }

    
    init(mainTask: String, subTask: String, date:String) {
        self.maintask = mainTask
        self.subtask = subTask
        self.date=date
    }
    
    
}
