//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

//Pour utiliser la Search bar il est important de declarer le protocole qui va nous permettre d'utiliser le delegate

class TodoListViewController: SwipeTableViewController {

    var todoItems: Results<Item>?
    let realm = try! Realm() // tjrs initialisé un realm
    
    var selectedCategory : Category? { //On identifie grace à cette variable qu'elle est la category qui a été selectionné par l'utilisateur
       // le code qui sera ecrit entre ces bracket va se trigger uniquement lorsque la variable aura une valeur car elle est marqué en tant que optionnal
        didSet {
            loadItems()
        }
        
    }
    // on va récuperer le fichier plist qui contient la dernière sauvegarde
    //let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    //let defaults = UserDefaults.standard // On stock les key-Value pairs de manière persistente. Use UserDefaults only  for small data. a utiliser seulement pour des variable ayant un data type standard et pour de ptite données
    
    
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorStyle = .none
        
       
        //print(dataFilePath)
        
        
//        let newItem = Item()
//        newItem.title = "Find Mike"
//        itemArray.append(newItem)
//
//        let newItem2 = Item()
//        newItem2.title = "Buy eggos"
//        itemArray.append(newItem2)
//
//        let newItem3 = Item()
//        newItem3.title = "Buy Muesli"
//        itemArray.append(newItem3)
        
        
        
       // loadItems() //Methode qui permet de charger les données sauvegarder dans la base de données
        
        //Permet de reinitisaliser les données qui ont été sauvegarder si on utilise le UserDefault
//        if let items = (defaults.array(forKey: "TodoListArray") as? [Item]) {
//           itemArray = items
//       }
        
    }

    
    //MARK: - UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Fonction qui permet de déterminer combien de ligne va avoir le TableView. Dans notre cas c'est equivalent au nombre de ligne dans le tableau messages
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Fonction qui permet de populate chaque ligne du TableView. Cette fonction est appelé auatant de fois qu'il y a de ligne dans le tableau messages
        
       // On verifie si le container qui contient les items n'est pas vide
          
            let cell = super.tableView(tableView, cellForRowAt: indexPath) // ce code remplace le dequeueReusableCell et permet d'appeler le cell qui est declaré dans la super classe
            
        if let item = todoItems?[indexPath.row] {
            
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
            
           
            // FlatSkyBlue = Une couleur proposé par le framework Camelon. l'option darken permet de créé un effet Gradient entre les couleurs. Il suffit du spécifier en entré un pourcentage. Dans notre cas pour avoir un effet gradient, il faut prend la position de l'item et le diviser par le nombre total d'item.
            // boucle if car FlatSkyBlue est optional
            
            let categoryColor = UIColor(hexString: selectedCategory?.backgroundColor ?? "1D9BF6")
             

            if let colour = categoryColor!.darken(byPercentage:CGFloat(indexPath.row) / CGFloat(todoItems!.count)) {
                
                cell.backgroundColor = colour
               // Ligne de code qui permet d'adapter la couleur du text en fonction de la couleur du background.
                cell.textLabel?.textColor = ContrastColorOf(colour, returnFlat: true)
                
            }
            
             
        } else {
            cell.textLabel?.text = "No Item added yet"
        }
        

            
            return cell
            
        
        
        }
    
    //MARK: - TableView Delegate Methods
   
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           // Fonction qui permet de donner l'index de la ligne du cell sur lequel l'utilisateur à cliqué et realiser une action lorsque la cell à etait selectionné
        
        // Update the realm data base
        if let item = todoItems?[indexPath.row] { // On verifie si le container qui contient les items n'est pas vide
          
            do {
            try realm.write {
                item.done = !item.done // On sauvegarde la valeur opposé de done. Exemple: si un item apparait en tant que check, l'état de done passera a false en cliquant sur le cell
            }
            } catch {
                print("Error saving done status, \(error)")
            }
            
            
            
        }
        
        
        tableView.reloadData()
        
        //saveItems()
        tableView.deselectRow(at: indexPath, animated: true) //Permet de "deselectionner" le cell une fois que l'utilisateur a cliqué dessus. C'est utile à des fin de user interface. Le cell deviendra gris une fraction de secondes puis redevient normal
      }
    
    
    
    //Mark - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert) // permet de créer une pop up lorsque on clique sur le boutton
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            // on créé un nouvel objet Item pour y stocker les différente valeur d'un Item
            // let newItem = Item() Utile pour le stockage utilisant les .plist et l'encodage
            
           
            
//            let newItem = Item(context: self.context) // Afin de pouvoir utiliser DataCore, il faut initialiser l'objet en utilisant l'option context et spécifier le context pour utiliser le delegate
//            newItem.title = textField.text!
//            newItem.done = false
//            newItem.parentCategory = self.selectedCategory // On set la clé unique parentCategory en fonction de la categorie que l'user à choisi. Cela veut dire que à chaque fois que un utilisateur va ajouter un nouvel item dans la categorie de son choix, cet item sera automatiquement associé à la catégorie
            
            if let currentCategory = self.selectedCategory { // On check si la category selectionné n'est pas nul
                
                do {
                    try self.realm.write { // On sauvegarde le nouvel item in our Realm
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem) // On rajoute le nouvel Item créé dans la liste des Item de la category selectionné
                    }
                    
                } catch {
                    print("Error saving context, \(error)")
                   
                }
            }
            
            
        
            
           // Permet de rafraichire la tableView ce qui ferra apparaitre le nouvel item dans un new cell
            self.tableView.reloadData()
        }
        
        // Permet de rajouter un text field dans la popup
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
           // Permet de sortir de cette closure le alertTextField qui contient le text de l'utilisateur qu'il a rentré de le textField
            textField = alertTextField
            
        }
        
        alert.addAction(action) // on ajoute l'action à notre alerte (pop up)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    
    
    //MARK: - Model Manupulation Methods
    

    
    func loadItems() {
        
       // ligne de code qui permet de recuperer les Item de la base de données realm par ordre alphabetique en filtrant sur le type de category a laquel l'item appartient
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)

        tableView.reloadData()

    }
    
    
    
    
    

}

//MARK: - SearchBar delegate


extension TodoListViewController: UISearchBarDelegate {

    // Fonction qui va premettre à l'utilisateur de rentrer dans le bar de recherche un texte et l'application va requeter la base de données pour récuperer les données correspondante
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        
        // Cette ligne permet de récuper seulement les items qui respecte le regex définit. En gros cela permet de recuperer les items via la bar de recherche
        //Predicate = Query ou un Regex
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()
        

    }

    // Cette methode est trigger a chaque fois qu'une nouvelle lettre est entré dans la bar de recherche. Dès que l'on appuie sur la croix, la table initial est chargée
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        // Dès qu'il n'y a plus de lettre dans la bar de recher on revient à la normal
        if searchBar.text?.count == 0 {
           loadItems()

           // DispatchQueue permet de mettre le thread entre les bracket au background. Cela permet à l'user d'interagir avec l'application sans attendre la fin du thread
            DispatchQueue.main.async {
                // Le searchbar n'est plus le first responder. En gros le search bar n'est plus selectionné
                searchBar.resignFirstResponder()
            }

        }

    }
    
    
    //MARK: - Delete Data From SwipeTableViewController
    
    // L'objectif ici est de réecrire la fonction updateModel initialement declaré dans la super classe SwipeTableViewControler. Cele va permettre de recuperer les données (category selectionné par l'utilisateur) qui sont disponible dans cette classe pour pouvoir trigger la fonction dans la super classe et supprimer la category
    override func updateModel(at indexPath: IndexPath) {
        // Ligne de code qui nous permet de supprimer une categorie
        
        if let itemForDeletion = todoItems?[indexPath.row] {

                do {
                    try self.realm.write {

                        self.realm.delete(itemForDeletion)
                    }

                } catch {
                    print("Error saving context, \(error)")

                }

                tableView.reloadData()
           }
    }
    
    
}


