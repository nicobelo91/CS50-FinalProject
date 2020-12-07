//
//  ViewController.swift
//  novence
//
//  Created by Nico Cobelo on 30/11/2020.
//

import UIKit
import CoreData
import SwipeCellKit
import ChameleonFramework

class ListViewController: UITableViewController {

    @IBOutlet var productsList: UITableView!
    var datePicker: UIDatePicker = UIDatePicker()
    var productArray = [Product]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var hex: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 80
        productsList.register(UINib(nibName: "ProductCell", bundle: nil), forCellReuseIdentifier: "ReusableCell")
        //print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        loadProducts()
        
    }

// MARK: - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath) as! ProductCell
        
        cell.delegate = self
        let product = productArray[indexPath.row]
        cell.productName.text = product.name
        var cellColor = CellManager(color: hex)
        
        //Format date into String
        if let expirationText = product.expiration {
            let expiration = cellColor.expirationDateText(date: expirationText)
            cell.expirationDate.text = expiration
        }
        
        //Change cell's background color
        if let secondsToExpiration = product.expiration?.timeIntervalSinceNow {

            let result = cellColor.chooseBackgroundColor(time: secondsToExpiration)
            hex = result
            cell.backgroundColor = UIColor(hexString: hex)
        }
        
        cell.productName.textColor = ContrastColorOf(cell.backgroundColor!, returnFlat: true)
        cell.expirationDate.textColor = ContrastColorOf(cell.backgroundColor!, returnFlat: true)
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
            productArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
        
        self.productArray.sort {
            $0.expiration! < $1.expiration!
        }
        tableView.reloadData()
    }
    
// MARK: - Add New Categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new product", message: "Add the name and its expiration date", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            let newProduct = Product(context: self.context)
            newProduct.name = textField.text
            newProduct.expiration = self.datePicker.date
            
            self.productArray.append(newProduct)
            self.saveProducts()
            self.loadProducts()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new product"
            textField = alertTextField
            self.doDatePicker()
            alertTextField.inputView = self.datePicker
        }
        
        //Grab the value from the text field and print it when the user clicks okay
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
// MARK: - Date Picker Methods
    
    func doDatePicker() {
        self.datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: 0, height: 150))
        self.datePicker.backgroundColor = UIColor.white
        datePicker.datePickerMode = .date
        
    }
}

// MARK: - SwipeCellKit

extension ListViewController: SwipeTableViewCellDelegate {

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil}

        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { [self] (action, indexPath) in

            self.context.delete(self.productArray[indexPath.row])
            self.productArray.remove(at: indexPath.row)
            saveProducts()
        }

        deleteAction.image = UIImage(named: "delete-icon")

        return [deleteAction]
    }
}

