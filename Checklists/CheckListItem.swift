//
//  CheckListItem.swift
//  Checklists
//
//  Created by Ilya Maxutov on 5/17/18.
//  Copyright © 2018 Ilya Maxutov. All rights reserved.
//

import Foundation

class CheckListItem: NSObject{
    var text = ""
    var checked = false
    
    func toggleChecked(){
        checked = !checked
    }
}
