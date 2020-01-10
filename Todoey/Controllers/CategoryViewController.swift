//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Arturo Lee on 1/7/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    var categories: Results<Category>?

    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
        tableView.separatorStyle =  .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let navBar = navigationController?.navigationBar else {return}
        let backgroundColor = UIColor(hexString: "1D9BF6")!
        let appearance = UINavigationBarAppearance().self
        appearance.backgroundColor = backgroundColor
        appearance.largeTitleTextAttributes = [
            NSAttributedString.Key.foregroundColor : ContrastColorOf(backgroundColor: backgroundColor, returnFlat: true)
        ]
        navBar.standardAppearance = appearance
        navBar.compactAppearance = appearance
        navBar.scrollEdgeAppearance = appearance
        navBar.tintColor = ContrastColorOf(backgroundColor: backgroundColor, returnFlat: true)
    }
    
    @IBAction func addButtonPressd(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Create New Category", message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            if let textField = alert.textFields?[0] {
                let newCategory = Category()
                newCategory.name = textField.text!
                newCategory.hexValue = UIColor.randomFlat()!.hexValue()
                self.save(category: newCategory)
            }
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Create new category"
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        let category = categories?[indexPath.row]
        let text = category?.name ?? "No Categories Added Yet"
        cell.textLabel?.text = text
        let backgroundColor = category?.hexValue ?? UIColor.randomFlat()!.hexValue()
        cell.backgroundColor = UIColor(hexString: backgroundColor)
        cell.textLabel?.textColor = ContrastColorOf(backgroundColor: UIColor(hexString: backgroundColor), returnFlat: true)
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
    //MARK: - Data Manipulation Methods
    
    func save(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print(error.localizedDescription)
        }
        tableView.reloadData()
    }
    
    func loadCategories() {
        categories = realm.objects(Category.self)
        tableView.reloadData()
    }
    
    //MARK: - Deletion
    
    override func updateModel(at indexPath: IndexPath) {
        if let categoryForDeletion = self.categories?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(categoryForDeletion)
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
}
