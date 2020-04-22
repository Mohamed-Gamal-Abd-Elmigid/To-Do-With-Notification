//
//  AllListsViewController.swift
//  Checklists
//
//  Created by mac on 4/21/20.
//  Copyright © 2020 ASD. All rights reserved.
//

import UIKit

class AllListsViewController: UITableViewController , ListDetailViewControllerDelegate
{
    let cellIdentifier = "ChecklistCell"
    var lists = [Checklist]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        
       var list = Checklist(name: "Birthdays")
       lists.append(list)
       list = Checklist(name: "Groceries")
       lists.append(list)
       list = Checklist(name: "Cool Apps")
       lists.append(list)
       list = Checklist(name: "To Do")
       lists.append(list)
        
        loadLists()
            
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
    }
    
    
    // MARK:- List Detail View Controller Delegates
    func listDetailViewControllerDidCancel( _ controller: ListDetailViewController)
    {
    navigationController?.popViewController(animated: true)
    }
    func listDetailViewController(_ controller: ListDetailViewController,didFinishAdding checklist: Checklist)
    {
        let newRowIndex = lists.count
        lists.append(checklist)
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
        navigationController?.popViewController(animated: true)
        saveLists()
    }
    
    func listDetailViewController(_ controller: ListDetailViewController,
    didFinishEditing checklist: Checklist)
    {
        if let index = lists.index(of: checklist)
            {
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) {
            cell.textLabel!.text = checklist.name
            }
        }
    navigationController?.popViewController(animated: true)
        saveLists()
    }
    
    
    override func tableView(_ tableView: UITableView,commit editingStyle: UITableViewCell.EditingStyle,forRowAt indexPath: IndexPath)
    {
        lists.remove(at: indexPath.row)
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
        saveLists()
    }
    
    override func tableView(_ tableView: UITableView,accessoryButtonTappedForRowWith indexPath: IndexPath)
    {
        let controller = storyboard!.instantiateViewController(withIdentifier: "ListDetailViewController") as! ListDetailViewController
            controller.delegate = self
            let checklist = lists[indexPath.row]
            controller.checklistToEdit = checklist
        navigationController?.pushViewController(controller,animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return lists.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        let chackList = lists[indexPath.row]
        cell.accessoryType = .detailDisclosureButton
        cell.textLabel?.text = chackList.name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
            let checklist = lists[indexPath.row]
            performSegue(withIdentifier: "ShowChecklist", sender: checklist)
        saveLists()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "ShowChecklist"
        {
            let controller = segue.destination as! ChecklistViewController
            controller.checklist = sender as? Checklist
        }
        else if segue.identifier == "AddChecklist"
        {
            let controller = segue.destination as! ListDetailViewController
            controller.delegate = self
        }
    }
    // Save Data
    func documentsDirectory() -> URL
     {
         let paths = FileManager.default.urls(for: .documentDirectory,in: .userDomainMask)
         return paths[0]
     }
     func dataFilePath() -> URL
     {
             return documentsDirectory().appendingPathComponent("All Lists.plist")
     }
     
    func saveLists()
    {
        let encoder = PropertyListEncoder()
        
        do
        {
            let data = try encoder.encode(lists)
            
            try data.write(to : dataFilePath() , options : Data.WritingOptions.atomic )
        }
        catch
        {
            print("Error in saving item array \(error.localizedDescription)")
        }
    }
    
    func loadLists()
    {
        let path = dataFilePath()
        
        if let data = try? Data(contentsOf: path)
        {
            let decoder = PropertyListDecoder()
            do {
                lists = try decoder.decode([Checklist].self, from: data)
            }
            catch
            {
                print("Error in Fetching Data \(error.localizedDescription)")
            }
        }
    }

}
