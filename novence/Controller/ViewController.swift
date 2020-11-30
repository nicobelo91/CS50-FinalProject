//
//  ViewController.swift
//  novence
//
//  Created by Nico Cobelo on 30/11/2020.
//

import UIKit
import CoreData

class ListViewController: UITableViewController {

    var products = [Product]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        loadProducts()
        
    }

// MARK: - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "productCell", for: indexPath)
        
        let product = products[indexPath.row]
        
        cell.textLabel?.text = product.name
        
        return cell
    }
    
// MARK: - Data Manipulation
    
    func saveProducts() {
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    func loadProducts(with request: NSFetchRequest<Product> = Product.fetchRequest()) {
        do {
            products = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
    }
    
// MARK: - Add New Categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Create New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            let newProduct = Product(context: self.context)
            newProduct.name = textField.text
            
            self.products.append(newProduct)
            self.saveProducts()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new category"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
// MARK: - Tableview Delegate Methods
    

    
}

//color palette

//ffefa0
//ffd57e
//fca652
//ac4b1c
