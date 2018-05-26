//
//  AddItemViewController.swift
//  Checklists
//
//  Created by Ilya Maxutov on 5/25/18.
//  Copyright © 2018 Ilya Maxutov. All rights reserved.
//

import UIKit

protocol ItemDetailViewDelegate: class {
    func addItemViewControllerDidCancel(_ controller: ItemDetailView)
    func addItemViewController(_ controller: ItemDetailView, didFinishAdding item: CheckListItem)
    func addItemViewController(_ controller: ItemDetailView, didFinishEditing item: CheckListItem)
}

class ItemDetailView: UITableViewController, UITextFieldDelegate {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    var itemToEdit: CheckListItem?
    
    weak var delegate : ItemDetailViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.largeTitleDisplayMode = .never
        
        textField.delegate = self
        
        if let item = itemToEdit{
            title = "Edit Item"
            textField.text = item.text
        }
        
        doneButton.isEnabled = true
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        textField.becomeFirstResponder()
    }
    
    @IBAction func cancel() {
        navigationController?.popViewController(animated: true)
        delegate?.addItemViewControllerDidCancel(self)
        
        
    }
    
    @IBAction func done() {
        if let itemToEdit = itemToEdit{
            itemToEdit.text = textField.text!
            delegate?.addItemViewController(self, didFinishEditing: itemToEdit)
        }
        else {
            let item = CheckListItem()
            item.text = textField.text!
            if item.text == ""{
                print("nope")
            }else {
                delegate?.addItemViewController(self, didFinishAdding: item)
            }
        }
  
        
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let oldText = textField.text!
        let stringRange = Range(range, in: oldText)
        let newText = oldText.replacingCharacters(in: stringRange!, with: string)
        if newText.isEmpty {
            doneButton.isEnabled = false
        } else {
            doneButton.isEnabled = true
        }
        return true
    }
    
    
}
