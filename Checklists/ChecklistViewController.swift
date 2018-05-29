//
//  ViewController.swift
//  Checklists
//
//  Created by Ilya Maxutov on 5/17/18.
//  Copyright © 2018 Ilya Maxutov. All rights reserved.
//

import UIKit

class ChecklistViewController: UITableViewController, ItemDetailViewDelegate, PushItemsDelegate {
    
    func addItemsToViewController(_ controller: CompletedTasksViewController, didPushSth items: [CheckListItem], itemsToUpdate oldItems: [CheckListItem]) {
        
        self.oldItems = oldItems
        
        //TODO: Write a code for adding new element here
        
        for el in items{
            addRow(element: el)
        }
        
        
        navigationController?.popViewController(animated: true)
    }
    
    
    
    
    
    func addItemsToViewControllerDidCancel(_ controller: CompletedTasksViewController) {
        navigationController?.popViewController(animated: true)
    }
    

    @IBOutlet weak var taskLabel: UILabel!
 
    
    func addItemViewControllerDidCancel(_ controller: ItemDetailView) {
        navigationController?.popViewController(animated: true)
    }
    
    func addItemViewController(_ controller: ItemDetailView, didFinishAdding item: CheckListItem) {
        navigationController?.popViewController(animated: true)
        
        addRow(element: item)
  
    }
    
    func addItemViewController(_ controller: ItemDetailView, didFinishEditing item: CheckListItem) {
        if let index = currentItems.index(of: item){
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath){
                configureText(for: cell, with: item)
                navigationController?.popViewController(animated: true)
            }
        }
    }
    
    
    var currentItems: [CheckListItem]
    var oldItems: [CheckListItem]
    

    required init?(coder aDecoder: NSCoder) {
        
        currentItems = [CheckListItem]()
        oldItems = [CheckListItem]()
        
        
//        // test items for oldItems
//        let row0Item = CheckListItem()
//        row0Item.text = "Walk the dog"
//        oldItems.append(row0Item)
//
//        let row1Item = CheckListItem()
//        row1Item.text = "Pray"
//        oldItems.append(row1Item)
//
//        let row2Item = CheckListItem()
//        row2Item.text = "Code"
//        oldItems.append(row2Item)

        
        super.init(coder: aDecoder)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "AddItem" {
            let controller = segue.destination as! ItemDetailView
            controller.delegate = self
        } else if segue.identifier == "EditItem" {
            let controller = segue.destination as! ItemDetailView
            controller.delegate = self
            if let indexPath = tableView.indexPath(for: sender as! UITableViewCell){
                controller.itemToEdit = currentItems[indexPath.row]
            }
        } else if segue.identifier == "CheckOldItems" {
            let controller = segue.destination as! CompletedTasksViewController
            controller.delegate = self
            controller.items = oldItems
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //navigationController?.navigationBar.prefersLargeTitles = true
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath){
            let item = currentItems[indexPath.row]
            
            item.toggleChecked()
            
            configureCheckmark(for: cell, with: item, indexPath: indexPath)
            
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        deleteRow(indexPath: indexPath)
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if currentItems.count != 0 {
            taskLabel.isHidden = true
        }else {
            taskLabel.isHidden = false
        }
        return currentItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Checklistitem", for: indexPath)
        
        let item = currentItems[indexPath.row]
        
        
        configureText(for: cell, with: item)
        configureCheckmark(for: cell, with: item, indexPath: indexPath)
        
        return cell
    }
    
    
    func configureText(for cell : UITableViewCell, with item : CheckListItem) {
        let label = cell.viewWithTag(1000) as! UILabel
        label.text = item.text
    }

    func configureCheckmark(for cell: UITableViewCell, with item: CheckListItem, indexPath: IndexPath) {
        let label = cell.viewWithTag(1001) as! UILabel
        
        if item.checked{
            label.text = "✅"
            deleteRow(indexPath: indexPath)
        }else {
            label.text = ""
        }
    }
    
    func deleteRow(indexPath: IndexPath){
        
        oldItems.append(currentItems[indexPath.row])
        
        currentItems.remove(at: indexPath.row)
        
        // without animation is just tableView.reloadData()
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
        
    }
    
    func addRow(element: CheckListItem) {
        element.checked = false
        currentItems.insert(element, at: 0)
        let indexPaths = [IndexPath(row: 0, section: 0)]
        tableView.insertRows(at: indexPaths, with: .automatic)
    }
    

}

