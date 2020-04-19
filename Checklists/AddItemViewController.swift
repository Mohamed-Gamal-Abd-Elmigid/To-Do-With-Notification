//
//  AddItemTableViewController.swift
//  Checklists
//
//  Created by mac on 4/18/20.
//  Copyright © 2020 ASD. All rights reserved.
//

import UIKit

protocol AddItemViewControllerDelegate: class
{
func addItemViewControllerDidCancel( _ controller: AddItemViewController)
func addItemViewController(_ controller: AddItemViewController,didFinishAdding item: ChecklistItem)
func addItemViewController(_ controller: AddItemViewController,didFinishEditing item: ChecklistItem)
}

class AddItemViewController: UITableViewController , UITextFieldDelegate
{
    
   // var checklistViewController: ChecklistViewController!
    
    weak var delegate : AddItemViewControllerDelegate?
        var itemToEdit : ChecklistItem?
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        
        textField.delegate = self
        if textField.text!.isEmpty
        {
            doneBarButton.isEnabled = false
        }
        
        if let item = itemToEdit
        {
            title = "Edit Item"
            textField.text = item.text
            doneBarButton.isEnabled = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(true)
        textField.becomeFirstResponder()
    }
    // table View Delegate
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath?
    {
        return nil
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 1
    }
        
    @IBAction func done(_ sender: Any)
    {
      if let item = itemToEdit
      {
        item.text = textField.text!
        delegate?.addItemViewController(self,didFinishEditing: item)
      }
      else
      {
      let item = ChecklistItem()
      item.text = textField.text!
      delegate?.addItemViewController(self, didFinishAdding: item)
      }
      //  checklistViewController.addItem(item)
       // navigationController?.popViewController(animated: true)
    }
    
    @IBAction func cancel(_ sender: Any)
    {
      //  navigationController?.popViewController(animated: true)
        delegate?.addItemViewControllerDidCancel(self)
    }
    
    // Text Field Delegate
      
      func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
      replacementString string: String) -> Bool
      {
        let text = (textField.text! as NSString).replacingCharacters(in: range, with: string)

              if text.isEmpty {
                doneBarButton.isEnabled = false
              } else {
              doneBarButton.isEnabled = true
              }
          return true
      }
      
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        doneBarButton.isEnabled = false
        return true
    }
    
}
