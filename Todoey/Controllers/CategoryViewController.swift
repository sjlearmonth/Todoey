//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Stephen Learmonth on 14/12/2021.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {

    var categories = Array<Category>()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
    }
    
    // MARK: - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell")!
        
        cell.textLabel?.text = categories[indexPath.row].name
        
        return cell
    }

    
    // MARK: - Data Manipulation Methods
    
    func saveCategories() {
        
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        
        do {
            categories = try context.fetch(request)
        } catch {
            print("Error fetching data from context: \(error)")
        }
        
        tableView.reloadData()
    }
        
    @objc func editingChangedHandler(_ sender: Any) {
        let textField = sender as! UITextField
        var responder : UIResponder! = textField
        while !(responder is UIAlertController) { responder = responder.next }
        let alert = responder as! UIAlertController
        alert.actions[0].isEnabled = (textField.text != "")
    }

    // MARK: - Add New Category
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alertController = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Add", style: .default) { action in
            if textField.text != "" {
                
                let newCategory = Category(context: self.context)
                newCategory.name = textField.text!
                self.categories.append(newCategory)
                self.saveCategories()
            }
        }
        
        alertController.addTextField { alertTextField in
            alertTextField.placeholder = "Create new category"
            textField = alertTextField
            alertTextField.addTarget(self, action: #selector(self.editingChangedHandler), for: .editingChanged)
        }
        
        alertController.addAction(alertAction)
        alertController.actions[0].isEnabled = false
        present(alertController, animated: true, completion: nil)

    }
    
    // MARK: - Tableview Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "fromCategoryToItems", sender: self)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories[indexPath.row]
        }
    }
}
