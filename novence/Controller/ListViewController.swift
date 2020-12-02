//
//  ViewController.swift
//  novence
//
//  Created by Nico Cobelo on 30/11/2020.
//

import UIKit
import CoreData

class ListViewController: UITableViewController {

    @IBOutlet var productsList: UITableView!
    var datePicker: UIDatePicker = UIDatePicker()
    let toolBar = UIToolbar()
    var products = [Product]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        productsList.register(UINib(nibName: "ProductCell", bundle: nil), forCellReuseIdentifier: "ReusableCell")
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        loadProducts()
        
    }

// MARK: - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath) as! ProductCell
        
        
        let product = products[indexPath.row]
        
        cell.productName.text = product.name
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        let formatteddate = formatter.string(from: product.expiration ?? Date(timeIntervalSinceReferenceDate: 0))
        cell.expirationDate.text = formatteddate
        
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
        
        let alert = UIAlertController(title: "Add new product", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            let newProduct = Product(context: self.context)
            newProduct.name = textField.text
            newProduct.expiration = self.datePicker.date
            
            self.products.append(newProduct)
            self.saveProducts()
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
//        var textField = UITextField()
//
//        let alert = UIAlertController(title: "Create New Category", message: "", preferredStyle: .alert)
//
//        let action = UIAlertAction(title: "Add", style: .default) { (action) in
//            let newProduct = Product(context: self.context)
//            newProduct.name = textField.text
//
//            self.products.append(newProduct)
//            self.saveProducts()
//        }
//
//        alert.addTextField { (alertTextField) in
//            alertTextField.placeholder = "Create new category"
//            textField = alertTextField
//        }
//
//        alert.addAction(action)
//
//        present(alert, animated: true, completion: nil)
    }
    
// MARK: - Tableview Delegate Methods
    
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

//color palette

//ffefa0
//ffd57e
//fca652
//ac4b1c
