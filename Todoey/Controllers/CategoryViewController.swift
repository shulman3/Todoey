//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Victoria Shulman on 12/28/18.
//  Copyright © 2018 Victoria Shulman. All rights reserved.
//

import UIKit
import CoreData
class CategoryViewController: UITableViewController {

    var categoryArray = [Category]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        loadCategories()
    }

  
    
    //MARK: - Table View datasource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        let category = categoryArray[indexPath.row]
        
        cell.textLabel?.text = category.name
        
        return cell
    }
    

    //MARK: - Data Manipulation Methods CRUD
    
    func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest()){
        print("Called load categories")
        do{
            categoryArray = try context.fetch(request)
        }
        catch{
            print("Error loading context \(error)")
        }
        tableView.reloadData()
    }
    
    func saveCategories(){
        do{
            try context.save()
        }
        catch{
            print("Error saving context \(error)")
        }
        
        tableView.reloadData()
        
    }
    //MARK: - TableView delegate methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "GoToItems", sender: self)
        
    }
    
    //MARK: - Add New Categories
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title:"Add New ToDoey Category"
            , message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            
            let newCategory = Category(context: self.context)
            
            newCategory.name = textField.text ?? "New Category"
            
            self.categoryArray.append(newCategory)
            
            self.saveCategories()
            
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Category"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert,animated: true, completion: nil)
    }
    
   
}
