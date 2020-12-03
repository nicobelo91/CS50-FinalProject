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
    let toolBar = UIToolbar()
    var productArray = [Product]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tableView.rowHeight = 80
        productsList.register(UINib(nibName: "ProductCell", bundle: nil), forCellReuseIdentifier: "ReusableCell")
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
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
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        let formatteddate = formatter.string(from: product.expiration ?? Date(timeIntervalSinceReferenceDate: 0))
        cell.expirationDate.text = formatteddate
        
        let secondsToExpiration = product.expiration?.timeIntervalSinceNow
        

        if secondsToExpiration! < 0 { //already expired
            cell.backgroundColor = UIColor(hexString: "39311d")
        } else if secondsToExpiration! < 259200.0 { //three days to expiration date
            cell.backgroundColor = UIColor(hexString: "ac4b1c")
        } else if secondsToExpiration! < 604800.0 { //seven days to expiration date
            cell.backgroundColor = UIColor(hexString: "fca652")
        } else if secondsToExpiration! < 1296000.0 { //fifteen days to expiration date
            cell.backgroundColor = UIColor(hexString: "ffd57e")
        } else {
            cell.backgroundColor = UIColor(hexString: "ffefa0")
        }
        cell.productName.textColor = ContrastColorOf(cell.backgroundColor!, returnFlat: true)
        cell.expirationDate.textColor = ContrastColorOf(cell.backgroundColor!, returnFlat: true)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        context.delete(productArray[indexPath.row])
        productArray.remove(at: indexPath.row)
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
        
        let alert = UIAlertController(title: "Add new product", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            let newProduct = Product(context: self.context)
            newProduct.name = textField.text
            newProduct.expiration = self.datePicker.date
            
            self.productArray.append(newProduct)
            self.saveProducts()
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new product"
            textField = alertTextField
            self.doDatePicker()
            alertTextField.inputView = self.datePicker
            alertTextField.inputAccessoryView = self.toolBar
        }
        
        //Grab the value from the text field and print it when the user clicks okay
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    
// MARK: - Date Picker Methods
    
    func doDatePicker() {
        self.datePicker = UIDatePicker(frame: CGRect(x: 0, y: self.view.frame.size.height - 220, width: self.view.frame.size.width, height: 216))
        self.datePicker.backgroundColor = UIColor.white
        datePicker.datePickerMode = .date
        
        //toolbar
        
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
        toolBar.sizeToFit()
        
        //Adding button toolbar
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelClick))
        toolBar.setItems(([cancelButton,spaceButton,doneButton]), animated: true)
        toolBar.isUserInteractionEnabled = true
        
    }
    
    @objc func doneClick() {
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateStyle = .medium
        dateFormatter1.timeStyle = .none
        
        datePicker.isHidden = true
        self.toolBar.isHidden = true
    }
    
    @objc func cancelClick() {
        datePicker.isHidden = true
        self.toolBar.isHidden = true
    }
    
}

// MARK: - SearchBar Methods

extension ListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request: NSFetchRequest<Product> = Product.fetchRequest()
        request.predicate = NSPredicate(format: "name CONTAINS[cd] %@", searchBar.text!)
        
        loadProducts(with: request)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadProducts()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}

// MARK: - SwipeCellKit

extension ListViewController: SwipeTableViewCellDelegate {
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil}
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { (action, indexPath) in
            
            print(self.productArray[indexPath.row])
//            self.context.delete(productArray[indexPath.row])
//            self.productArray.remove(at: indexPath.row)
        }
        
        deleteAction.image = UIImage(named: "delete-icon")
        
        return [deleteAction]
    }
    
    
}

//color palette


