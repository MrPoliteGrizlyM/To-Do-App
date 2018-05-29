//
//  CompletedTasksViewController.swift
//  To-Do App
//
//  Created by Ilya Maxutov on 5/28/18.
//  Copyright © 2018 Ilya Maxutov. All rights reserved.
//

import UIKit

protocol PushItemsDelegate: class {
    func addItemsToViewController(_ controller: CompletedTasksViewController, didPushSth items: [CheckListItem], itemsToUpdate oldItems: [CheckListItem])
}


class CompletedTasksViewController: UITableViewController {
    
    
    var items: [CheckListItem] = []
    var itemsToPush: [CheckListItem] = []
    
    weak var delegate: PushItemsDelegate?
    
    @IBOutlet weak var textLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(CompletedTasksViewController.cancel(sender:)))
        self.navigationItem.leftBarButtonItem = cancelButton
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if items.count != 0 {
            textLabel.isHidden = true
        }else {
            textLabel.isHidden = false
        }
        return items.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Checklistitem", for: indexPath)
        
        let item = items[indexPath.row]
        let label = cell.viewWithTag(500) as! UILabel
        
        label.text = item.text
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        deleteRow(indexPath: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @objc func cancel(sender: UIBarButtonItem) {
        delegate?.addItemsToViewController(self, didPushSth: itemsToPush,itemsToUpdate: items)
        //navigationController?.popViewController(animated: true)
    }
    
    func deleteRow(indexPath: IndexPath){
        
        itemsToPush.append(items[indexPath.row])
        
        items.remove(at: indexPath.row)
        
        // without animation is just tableView.reloadData()
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
    }



}
