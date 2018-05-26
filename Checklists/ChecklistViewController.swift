//
//  ViewController.swift
//  Checklists
//
//  Created by Ilya Maxutov on 5/17/18.
//  Copyright © 2018 Ilya Maxutov. All rights reserved.
//

import UIKit

class ChecklistViewController: UITableViewController, ItemDetailViewDelegate {
    
    @IBOutlet weak var taskLabel: UILabel!
    
    func addItemViewControllerDidCancel(_ controller: ItemDetailView) {
        navigationController?.popViewController(animated: true)
    }
    
    func addItemViewController(_ controller: ItemDetailView, didFinishAdding item: CheckListItem) {
        navigationController?.popViewController(animated: true)
        
        let newRowIndex = 0 // items.count
        
        items.insert(item, at: 0) // append for adding to button
        let indexPaths = [IndexPath(row: newRowIndex, section: 0)]
        tableView.insertRows(at: indexPaths, with: .automatic)
        
    }
    
    func addItemViewController(_ controller: ItemDetailView, didFinishEditing item: CheckListItem) {
        if let index = items.index(of: item){
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath){
                configureText(for: cell, with: item)
                navigationController?.popViewController(animated: true)
            }
        }
    }
    
    
    var items: [CheckListItem]
    

    required init?(coder aDecoder: NSCoder) {
        
        items = [CheckListItem]()
        
//        let row0Item = CheckListItem()
//        row0Item.text = "Walk the dog"
//        items.append(row0Item)
//
//        let row1Item = CheckListItem()
//        row1Item.text = "Pray"
//        items.append(row1Item)
//
//        let row2Item = CheckListItem()
//        row2Item.text = "Code"
//        items.append(row2Item)
//
//        let row3Item = CheckListItem()
//        row3Item.text = "Work"
//        items.append(row3Item)
//
//        let row4Item = CheckListItem()
//        row4Item.text = "Eat"
//        items.append(row4Item)
//
//        let row5Item = CheckListItem()
//        row5Item.text = "Sleep"
//        items.append(row5Item)
//
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
                controller.itemToEdit = items[indexPath.row]
            }
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
            let item = items[indexPath.row]
            
            item.toggleChecked()
            
            configureCheckmark(for: cell, with: item)
            
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        
        items.remove(at: indexPath.row)
        
        // without animation is just tableView.reloadData()
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if items.count != 0 {
            taskLabel.isHidden = true
        }else {
            taskLabel.isHidden = false
        }
        
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Checklistitem", for: indexPath)
        
        let item = items[indexPath.row]
        
        
        configureText(for: cell, with: item)
        configureCheckmark(for: cell, with: item)
        
        return cell
    }
    
    func configureText(for cell : UITableViewCell, with item : CheckListItem) {
        let label = cell.viewWithTag(1000) as! UILabel
        label.text = item.text
    }

    func configureCheckmark(for cell: UITableViewCell, with item: CheckListItem) {
        let label = cell.viewWithTag(1001) as! UILabel
        
        if item.checked{
            label.text = "✅"
        }else {
            label.text = ""
        }
    }
    

}

