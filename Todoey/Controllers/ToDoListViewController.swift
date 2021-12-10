//
//  ToDoListViewController.swift
//  Todoey
//
//  Created by Stephen Learmonth on 26/11/2021.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController {
    
    var itemArray = Array<Item>()
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(dataFilePath)
        
//        loadItems()
        
    }
    //MARK: - TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell")!
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print("Did select item: \(itemArray[indexPath.row])")
        
        itemArray[indexPath.row].done.toggle()
        
        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Add new items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alertController = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Add Item", style: .default) { action in
            if textField.text != "" {
                
                let newItem = Item(context: self.context)
                newItem.title = textField.text!
                newItem.done = false
                self.itemArray.append(newItem)
                self.saveItems()
            }
        }
        
        alertController.addTextField { alertTextField in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
            alertTextField.addTarget(self, action: #selector(self.editingChangedHandler), for: .editingChanged)
        }
        
        alertController.addAction(alertAction)
        alertController.actions[0].isEnabled = false
        present(alertController, animated: true, completion: nil)
    }
    
    func saveItems() {
        
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
        
        self.tableView.reloadData()
    }
    
//    func loadItems() {
//        if let data = try? Data(contentsOf: dataFilePath!) {
//            let decoder = PropertyListDecoder()
//            do {
//            itemArray = try decoder.decode([Item].self, from: data)
//            } catch {
//                print("Error decoding item array, \(error)")
//            }
//        }
//    }
    
    @objc func editingChangedHandler(_ sender: Any) {
        let textField = sender as! UITextField
        var responder : UIResponder! = textField
        while !(responder is UIAlertController) { responder = responder.next }
        let alert = responder as! UIAlertController
        alert.actions[0].isEnabled = (textField.text != "")
    }
}

