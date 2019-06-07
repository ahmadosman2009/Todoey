//
//  ViewController.swift
//  Todoey
//
//  Created by Ahmad Osman on 5/30/19.
//  Copyright © 2019 Mido Apps. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift

class ToDoListViewController: UITableViewController {
    

    var todoItems : Results<Item>?
    let realm = try! Realm()
    var selectedCategory : Category? {
        didSet {
            loadItems()
        }
    }


    override func viewDidLoad() {
        super.viewDidLoad()

    }

    //MARK - TableView DataSource Methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            
            cell.accessoryType = (item.done == true) ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No items added yet"
        }
        
        
        
        
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    //MARK - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                }
            } catch {
                    print("Error saving done status, \(error)")
                }
            }
        tableView.reloadData()
        
//        print(itemArray[indexPath.row])
        
    
//        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true) //gray highlight is removed after clicking, doesn't stay
        
    }
    
    //MARK - Add New Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Item ()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date ()
                        currentCategory.items.append(newItem)
                    }
                } catch {
                    print("Error saving new item")
                }
                
            }
            
           
        
            self.tableView.reloadData()
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    
    
    func loadItems () {

       todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
    
   
    
}


extension ToDoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()

    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()

            DispatchQueue.main.async {
                searchBar.resignFirstResponder() //no longer cursor active or keyboard shown
            }


        }
    }
}

