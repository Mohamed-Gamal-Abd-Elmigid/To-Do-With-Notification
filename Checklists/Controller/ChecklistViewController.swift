//
//  ViewController.swift
//  Checklists
//
//  Created by mac on 4/16/20.
//  Copyright © 2020 ASD. All rights reserved.
//

import UIKit

class ChecklistViewController : UITableViewController , AddItemViewControllerDelegate
{
    var checklist: Checklist!
    @IBOutlet weak var checkLabel: UILabel!
    var items = [ChecklistItem]()
   
    override func viewDidLoad()
    {
       navigationController?.navigationBar.prefersLargeTitles = false
        
        super.viewDidLoad()
        title = checklist.name
        loadCheckItems()
        
//        print("Documents folder is \(documentsDirectory())")
//        print("Data file path is \(dataFilePath())")
     
        tableView.dataSource = self
//        let item1 = ChecklistItem()
//        item1.text = "Walk the dog"
//        items.append(item1)
//            
//        
//        let item2 = ChecklistItem()
//        item2.text = "Brush my teeth"
//        item2.checked = true
//        items.append(item2)
//        
//        
//        let item3 = ChecklistItem()
//        item3.text = "Learn iOS development"
//        item3.checked = true
//        items.append(item3)
//        
//        let item4 = ChecklistItem()
//        item4.text = "Soccer practice"
//        items.append(item4)
//        
//        
//        let item5 = ChecklistItem()
//        item5.text = "Eat ice cream"
//        items.append(item5)
    }
    
    // Data Presistant
    
    func documentsDirectory() -> URL
    {
        let paths = FileManager.default.urls(for: .documentDirectory,in: .userDomainMask)
        return paths[0]
    }
    func dataFilePath() -> URL
    {
            return documentsDirectory().appendingPathComponent("Checklists.plist")
    }
    

    
    // The Delegate Method
    
    func addItemViewController(_ controller: AddItemViewController, didFinishEditing item: ChecklistItem)
    {
        if let index = checklist.items.firstIndex(of: item)
            {
                let indexPath = IndexPath(row: index, section: 0)
                    if let cell = tableView.cellForRow(at: indexPath)
                    {
                        configureText(for: cell, with: item)
                        print("Error in edithing")
                        
                    }
            }
            navigationController?.popViewController(animated:true)
            
        saveCheckItems()
      }
            
    func addItemViewController(_ controller: AddItemViewController, didFinishAdding item: ChecklistItem)
    {
        let newRowIndex = checklist.items.count
        checklist.items.append(item)
        
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
        
        navigationController?.popViewController(animated: true)
        
        saveCheckItems()
    }
    
    func addItemViewControllerDidCancel(_ controller: AddItemViewController)
    {
        navigationController?.popToRootViewController(animated: true)
    }
    
    //Delete Rows
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)
    {
        checklist.items.remove(at: indexPath.row)
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
        
        saveCheckItems()
        
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
            if let cell = tableView.cellForRow(at: indexPath)
            {
                let item = checklist.items[indexPath.row]
                item.checked = !item.checked
                //  configureCheckmark(for: cell, at: indexPath)
//            }
            }
            tableView.deselectRow(at: indexPath, animated: true)
        
        saveCheckItems()
    }
    //Table View Data Source 

    override func tableView(_ tableView: UITableView,numberOfRowsInSection section: Int) -> Int
    {
        return checklist.items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
    
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem",for: indexPath)
        let item = checklist.items[indexPath.row]
        let label = cell.viewWithTag(1000) as! UILabel
        label.text = item.text
        //configureCheckmark(for: cell, at: indexPath)
        //cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
        return cell

    }
    
//  func configureCheckmark(for cell: UITableViewCell,
//    at indexPath: IndexPath)
//   {
//        let item = items[indexPath.row]
//        if item.checked
//        {
//        cell.accessoryType = .checkmark
//
//        } else {
//        cell.accessoryType = .none
//        }
//
//    }
//    func configureCheckmark(for cell: UITableViewCell,
//    with item: ChecklistItem)
//    {
//    let label = cell.viewWithTag(1001) as! UILabel
//    if item.checked {
//            label.text = "√"
//        } else {
//        label.text = ""
//        }
//    }
    
    func configureText(for cell: UITableViewCell,
    with item: ChecklistItem)
    {
        let label = cell.viewWithTag(1000) as! UILabel
        label.text = item.text
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "AddItem"
        {
            let controller = segue.destination as! AddItemViewController
            controller.delegate = self
        }
        else if segue.identifier == "EditItem"
        {
            let controller = segue.destination as! AddItemViewController
            controller.delegate = self
            if let indexPath = tableView.indexPath(for: sender as! UITableViewCell) {
                controller.itemToEdit = checklist.items[indexPath.row]
                }
            }
    }
    
    func saveCheckItems()
    {
        let encoder = PropertyListEncoder()
        
        do
        {
            let data = try encoder.encode(items)
            
            try data.write(to : dataFilePath() , options : Data.WritingOptions.atomic )
        }
        catch
        {
            print("Error in saving item array \(error.localizedDescription)")
        }
    }
    
    func loadCheckItems()
    {
        let path = dataFilePath()
        
        if let data = try? Data(contentsOf: path)
        {
            let decoder = PropertyListDecoder()
            do {
                items = try decoder.decode([ChecklistItem].self, from: data)
            }
            catch
            {
                print("Error in Fetching Data \(error.localizedDescription)")
            }
        }
    }
    
    // Re order table view cell
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath)
    {
        let itemToMove = items[sourceIndexPath.row]
        items.remove(at: sourceIndexPath.row)
        items.insert(itemToMove, at: destinationIndexPath.row)
        saveCheckItems()
    }
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    @IBAction func startEditing(_ sender: Any) {
        isEditing = !isEditing
    }
}

