//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Tajgalt on 18/04/2021.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {

    var categoryArray = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()

        
    }


   
    
    
    //MARK: - TableView Data source Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Fonction qui permet de déterminer combien de ligne va avoir le TableView. Dans notre cas c'est equivalent au nombre de ligne dans le tableau messages
        return categoryArray.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Fonction qui permet de populate chaque ligne du TableView. Cette fonction est appelé auatant de fois qu'il y a de ligne dans le tableau messages
        
        let category = categoryArray[indexPath.row]
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) //Cell = Un message. Cette ligne de code permet de créé un reusable cell
        cell.textLabel?.text = category.name
    
        return cell
        
        
        }
    
    
    
    //MARK: - TableView Delegate Methods
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    
    // fonction appelé lorsque le perform la Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
        // On créé le View Controller que l'on souhaite faire apparaitre en tant que TodoListViewController
        let destinationVC = segue.destination as! TodoListViewController
        
        //identify the current row that is selected
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
        
        
    }
    
    
    
    
    
    //MARK: - Add New Categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Category", message: "", preferredStyle: .alert) // permet de créer une pop up lorsque on clique sur le boutton
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            // on créé un nouvel objet Item pour y stocker les différente valeur d'un Item
            // let newItem = Item() Utile pour le stockage utilisant les .plist et l'encodage
            
           
            
            let newCategory = Category(context: self.context) // Afin de pouvoir utiliser DataCore, il faut initialiser l'objet en utilisant l'option context et spécifier le context pour utiliser le delegate
            newCategory.name = textField.text!
            
            
            // On rajouter la categorye créé par l'user dans notre tableau
            self.categoryArray.append(newCategory)
            
            // Permet de sauvegarder les modifs de l'utilisateur dans notre defaults
           // self.defaults.set(self.itemArray, forKey: "TodoListArray") //Tjrs renseigner une clé pour récupérer les data par la suite
           
            self.saveCategories()
            
           // Permet de rafraichire la tableView ce qui ferra apparaitre le nouvel item dans un new cell
            self.tableView.reloadData()
        }
        
        // Permet de rajouter un text field dans la popup
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new category" // titre du textfield en background
           // Permet de sortir de cette closure le alertTextField qui contient le text de l'utilisateur qu'il a rentré de le textField
            textField = alertTextField
            
        }
        
        alert.addAction(action) // on ajoute l'action à notre alerte (pop up)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    
    
    //MARK: - Data Manipulation methods
    
    func saveCategories() {
        
       
        // Block de code permettant de sauvegarder les items dans la tablke CoreData
        do {
            try self.context.save()
            
        } catch {
            print("Error saving context, \(error)")
           
        }
        
        
    }
    
    func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest()) { // la notation du = au sein de la fonction signifie que l'on spécifie une valeur par défaut si aucune valeur n'est declaré
    
        // code qui va permettre de lire les données sauvegarder dans la base de données CoreData
        // On créé la requete en specifiant le type d'objet que l'on souhaite récupérer
    //let request : NSFetchRequest<Item> = Item.fetchRequest()
   
        // On met à jour le itemArray en récuperant les données de la DB
        do {
        categoryArray = try context.fetch(request)
    } catch {
        print("Error fetching data from context\(error)")
    }
        
        tableView.reloadData()
    
    }
    
    
    
    
}
