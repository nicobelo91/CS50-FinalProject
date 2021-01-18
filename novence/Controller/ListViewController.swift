//
//  ViewController.swift
//  novence
//
//  Created by Nico Cobelo on 30/11/2020.
//

import UIKit
import CoreData
import ChameleonFramework
import AlertsAndPickers

class ListViewController: UITableViewController {

    @IBOutlet var productsList: UITableView!
    var datePicker: UIDatePicker = UIDatePicker()
    var productArray = [Product]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var hex: String = ""
    var currentTime = NSDate.init(timeIntervalSinceNow: 0)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        productsList.register(UINib(nibName: "ProductCell", bundle: nil), forCellReuseIdentifier: "ProductCell")
        //print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        loadProducts()
    }

// MARK: - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell", for: indexPath) as! ProductCell
        
        let product = productArray[indexPath.row]
        cell.productName.text = product.name
        var cellColor = CellManager(color: hex)
        
        //Format date into String
        if let expirationText = product.expiration {
            let expiration = cellColor.expirationDateText(date: expirationText)
            cell.expirationDate.text = expiration
        }
        
        //Change cell's background color depending on today's date
        if let productsExpirationTime = product.expiration?.timeIntervalSinceNow {
            let secondsToExpiration = productsExpirationTime - currentTime.timeIntervalSinceNow
                hex = cellColor.chooseBackgroundColor(time: secondsToExpiration)
                cell.backgroundColor = UIColor(hexString: hex)
            //print(productsExpirationTime)
            }
        
            cell.productName.textColor = ContrastColorOf(cell.backgroundColor!, returnFlat: true)
            cell.expirationDate.textColor = ContrastColorOf(cell.backgroundColor!, returnFlat: true)
            return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.context.delete(self.productArray[indexPath.row])
            productArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            saveProducts()
        }
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
        let date = Date()
        let minDate = Date(timeIntervalSinceNow: -1234567890)
        let maxDate = Date(timeIntervalSinceNow: 1234567890)
        datePicker.preferredDatePickerStyle = .inline
        
        let alert = UIAlertController(title: "Add new product", message: "Add the name and its expiration date", preferredStyle: .alert)
        
        let addProductAction = UIAlertAction(title: "Add", style: .default) { (action) in
            let newProduct = Product(context: self.context)
            newProduct.name = textField.text
            newProduct.expiration = self.datePicker.date
            
            self.productArray.append(newProduct)
            self.saveProducts()
            self.loadProducts()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add new item"
            textField = alertTextField
        }
        
        alert.addDatePicker(mode: .date, date: date, minimumDate: minDate, maximumDate: maxDate) { SelectedDate in
            self.datePicker.date = SelectedDate
            self.datePicker.preferredDatePickerStyle = .inline
            
        }
        
        //Grab the value from the text field and print it when the user clicks add
        alert.addAction(addProductAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
        
    }
}
