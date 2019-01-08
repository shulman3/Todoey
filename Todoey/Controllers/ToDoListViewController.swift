//
//  ViewController.swift
//  Todoey
//
//  Created by Victoria Shulman on 12/14/18.
//  Copyright © 2018 Victoria Shulman. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class ToDoListViewController: SwipeTableViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    let realm = try! Realm()
    var todoItems : Results<Item>?
    
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        tableView.separatorStyle = .none
       
    }
    
    override func viewWillAppear(_ animated: Bool){
        guard let colorHex = selectedCategory?.color else{fatalError("No color")}
        
        title = selectedCategory!.name
        
        updateNavBar(withHexCode: colorHex)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        updateNavBar(withHexCode: "1098F6")
    }
    
    //MARK: - Nav bar setup methods
    func updateNavBar(withHexCode colorHex: String){
        
        guard let navBar = navigationController?.navigationBar else {fatalError("Navigation is not yet available")}
        
        guard let navBarColor = UIColor(hexString: colorHex) else{fatalError("No color")}
        navBar.barTintColor = navBarColor
        navBar.tintColor = ContrastColorOf(navBarColor, returnFlat: true)
        navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : ContrastColorOf(navBarColor, returnFlat: true)]
        
        searchBar.barTintColor = navBarColor
        
    }
    
    //MARK: - Table View datasource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            
            cell.accessoryType = item.done == true ? .checkmark : .none
            
            if let color = UIColor(hexString: selectedCategory?.color ?? FlatWhite().hexValue())!.darken(byPercentage:
                CGFloat(indexPath.row) / CGFloat(todoItems!.count)){
                cell.backgroundColor = color
                cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
            }
        }
        else{
            
            cell.textLabel?.text = "No items added"
            
        }
        
        return cell
    }
    //MARK: - Table View delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = todoItems?[indexPath.row]{
            do{
                try realm.write {
                    item.done = !item.done
                    //realm.delete(item)
                }
            }
            catch{
                print("Error saving to realm \(error)")
            }
            
            
        }
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    //MARK: - Add new items section
    @IBAction func AddButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()

        let alert = UIAlertController(title:"Add New ToDoey Item"
            , message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            
            
            if let currentCategory = self.selectedCategory{
                do{
                    try self.realm.write {
                        let newItem = Item()
                    
                        newItem.title = textField.text ?? "New Item"
                        newItem.dateCreated = Date()
                        
                        currentCategory.items.append(newItem)
                    }
                }
                catch{
                    print("Error writin to realm \(error)")
                }
                
            }
            self.tableView.reloadData()
            
            
            
            
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert,animated: true, completion: nil)
    }
   
   
    func loadItems(){
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()
    }
    
    //MARK: - Delete data from swipe:
    override func updateModel(at indexPath: IndexPath) {
        if let item = self.todoItems?[indexPath.row] {
            do{
                try self.realm.write {
                    self.realm.delete(item)
                }
                
            }
            catch{
                print("Error saving context \(error)")
            }
        }
    }
    
    
}
// MARK: - Search bar methods

extension ToDoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
     
        tableView.reloadData()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0{
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        }
    }
}



