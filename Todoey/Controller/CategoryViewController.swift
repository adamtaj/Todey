//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Tajgalt on 18/04/2021.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework


class CategoryViewController: SwipeTableViewController { // On a créé une super classe Swipe exprès pour profiter du code pour Swiper
    
    // on initialise un realm
    let realm = try! Realm()
    
    var categoryArray: Results<Category>? // On le declare en tant que results pour pouvoir recuperer les données dans une realm database. Cf : LoadCategories method
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories() // on met à jour l'interface avec toutes les categories qui ont été save
        
        tableView.separatorStyle = .none // Nous permet de supprimer les separation entre les cell
       
        
    }
    
    
    
    
    
    //MARK: - TableView Data source Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Fonction qui permet de déterminer combien de ligne va avoir le TableView. Dans notre cas c'est equivalent au nombre de ligne dans le tableau messages
        return categoryArray?.count ?? 1 //On sécurise le fait que si category est nill on retourne 1
    }
    
    
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        // Fonction qui permet de populate chaque ligne du TableView. Cette fonction est appelé auatant de fois qu'il y a de ligne dans le tableau messages
        // Cette methode à été dans un premeir temps déclarer dans la super classe SwipeTableViewController
        
        let category = categoryArray?[indexPath.row]
        
        
       //  let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! SwipeTableViewCell //Cell = Un message. Cette ligne de code permet de créé un reusable cell. Cette ligne de code est initialisé dans la fonction dans la super classe
        // on downcast le cel en SwipeTableViewCell pour pouvoir profiter des fonctionnalité de la library qui permet de swiper une cell et proposer des actions
        let cell = super.tableView(tableView, cellForRowAt: indexPath) // ce code remplace le dequeueReusableCell et permet d'appeler le cell qui est declaré dans la super classe
        
        cell.textLabel?.text = category?.name ?? "No Categories added yet"
       // cell.delegate = self
       
        
        // pour convertir un string en UIColor : UIColor(hexString: String)
        cell.backgroundColor = UIColor(hexString: category?.backgroundColor ?? "1D9BF6")
        
        
        
        return cell
        
        
    }
    
    
    
    //MARK: - TableView Delegate Methods
    
    // Fonction appelé lorsque l'on clique sur un cell
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    
    // fonction appelé lorsque le perform la Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // On créé le View Controller que l'on souhaite faire apparaitre en tant que TodoListViewController
        let destinationVC = segue.destination as! TodoListViewController
        
        //identify the current row that is selected
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray?[indexPath.row]
        }
        
        
    }
    
    
    
    
    
    //MARK: - Add New Categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Category", message: "", preferredStyle: .alert) // permet de créer une pop up lorsque on clique sur le boutton
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            
            
            
            
            let newCategory = Category() // On initie une nouvelle category
            newCategory.name = textField.text!
            newCategory.backgroundColor = UIColor.randomFlat().hexValue() //Permet de changer le background du cell avec une couleur aléatoir qui vient du Cameleon framework. Le hexValue permet de convertir la couleur en string
            
            
            // On rajouter la category créé par l'user dans notre tableau
            // self.categoryArray.append(newCategory) dans le cas de l'utilisation du realm, nous n'avons plus besoin de mettre à jour le tableau. Cela est fait automatiquement
            
            
            self.saveCategories(category: newCategory)
            
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
    
    func saveCategories(category: Category) {
        
        
        // Block de code permettant de sauvegarder les items dans la db realm
        do {
            try realm.write {
                realm.add(category)
            }
            
        } catch {
            print("Error saving context, \(error)")
            
        }
        
        
    }
    
    func loadCategories() {
        
        categoryArray = realm.objects(Category.self) // Ligne de code qui va recuperer toutes les données dans notre realm ayant le type Category. Attnetion à ne pas oublier de declarer le category Array en tant que results
        
        
        
        
        tableView.reloadData()
        
    }
    
    
    //MARK: - Delete Data From SwipeTableViewController
    
    // L'objectif ici est de réecrire la fonction updateModel initialement declaré dans la super classe SwipeTableViewControler. Cele va permettre de recuperer les données (category selectionné par l'utilisateur) qui sont disponible dans cette classe pour pouvoir trigger la fonction dans la super classe et supprimer la category
    override func updateModel(at indexPath: IndexPath) {
        // Ligne de code qui nous permet de supprimer une categorie
            if let categoryForDeletion = self.categoryArray?[indexPath.row] {

                do {
                    try self.realm.write {

                        self.realm.delete(categoryForDeletion)
                    }

                } catch {
                    print("Error saving context, \(error)")

                }

                tableView.reloadData()
           }
    }
    
}




