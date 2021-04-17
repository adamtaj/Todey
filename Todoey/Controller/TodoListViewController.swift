//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {

    var itemArray = [Item]()
    
    // on va récuperer le fichier plist qui contient la dernière sauvegarde
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    //let defaults = UserDefaults.standard // On stock les key-Value pairs de manière persistente. Use UserDefaults only  for small data. a utiliser seulement pour des variable ayant un data type standard et pour de ptite données
    
    
    // On créé le context. On va utiliser le delegate en le declarant ainsi UIApplication.shared.delegate as! AppDelegate
     // shared is the singelton pbject of UIApplication
     let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        //loadItems() //Methode qui permet de charger les données sauvegarder le .plist
        
        //Permet de reinitisaliser les données qui ont été sauvegarder si on utilise le UserDefault
//        if let items = (defaults.array(forKey: "TodoListArray") as? [Item]) {
//           itemArray = items
//       }
        
    }

    
    //MARK: - UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Fonction qui permet de déterminer combien de ligne va avoir le TableView. Dans notre cas c'est equivalent au nombre de ligne dans le tableau messages
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Fonction qui permet de populate chaque ligne du TableView. Cette fonction est appelé auatant de fois qu'il y a de ligne dans le tableau messages
        
        let item = itemArray[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToItemCell", for: indexPath) //Cell = Un message
        cell.textLabel?.text = item.title
        //cell.textLabel?.text = messages[indexPath.row].body // permet de mettre le message associé à la ligne séléctionné dans une cell. Cette ligne de code suppose que c'est un cell par defaut
        
        
        
        
        // Condition qui permet de verifier si la cell est marqué comme check ou non. Le bolléen done nous pourmet de savoir s'il faut checker ou non l'item en fonction des cliques de l'user
        
        // Ternary operator ==> format spécial qui peut remplacer un if
        //Syntaxe : value = condition ? valueIfTrue : valueIfFalse
        
        cell.accessoryType = item.done == true ? .checkmark : .none // this ligne replace the if statement below
        
    
//        if itemArray[indexPath.row].done == true {
//            cell.accessoryType = .checkmark
//        } else {
//            cell.accessoryType = .none
//        }
        
       
        
        
        return cell
        
        
        }
    
    
    //Mark - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           // Fonction qui permet de donner l'index de la ligne du cell sur lequel l'utilisateur à cliqué
    
        //print(itemArray[indexPath.row])
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done //cette ligne de code permet d'inverser la valeur du boléen contenu dans done et remplace la boucle if ci-dessous
//        if itemArray[indexPath.row].done == false {
//            itemArray[indexPath.row].done = true
//        } else {
//            itemArray[indexPath.row].done = false
//        }
        
        
        tableView.reloadData() //permet de de reload les data et mettre à jour les items avec les dernière données
        
//       // Condition qui permet de verifier si la cell est marqué comme check ou non. Cette boucle à été remplacé dans une autre fonction cf : CellForRawAt
//        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
//            tableView.cellForRow(at: indexPath)?.accessoryType = .none
//        } else {
//            // Ligne de code qui permet d'ajouter l'accessoire checkmark dans toutes les cells
//            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
//        }
        
        
        saveItems()
        tableView.deselectRow(at: indexPath, animated: true) //Permet de "deselectionner" le cell une fois que l'utilisateur a cliqué dessus. C'est utile à des fin de user interface. Le cell deviendra gris une fraction de secondes puis redevient normal
      }
    
    
    
    //Mark - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert) // permet de créer une pop up lorsque on clique sur le boutton
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            // on créé un nouvel objet Item pour y stocker les différente valeur d'un Item
            // let newItem = Item() Utile pour le stockage utilisant les .plist et l'encodage
            
           
            
            let newItem = Item(context: self.context) // Afin de pouvoir utiliser DataCore, il faut initialiser l'objet en utilisant l'option context et spécifier le context pour utiliser le delegate
            newItem.title = textField.text!
            newItem.done = false
            
            // What will happen once the user click the add Item button on our UIAlert pop up
            self.itemArray.append(newItem)
            
            // Permet de sauvegarder les modifs de l'utilisateur dans notre defaults
           // self.defaults.set(self.itemArray, forKey: "TodoListArray") //Tjrs renseigner une clé pour récupérer les data par la suite
           
            self.saveItems()
            
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
    
    func saveItems() {
        
       
        // Block de code permettant de sauvegarder les items dans la tablke CoreData
        do {
            try self.context.save()
            
        } catch {
            print("Error saving context, \(error)")
           
        }
        
//        // Utile pour sauvegarder les données dans un plist
        // Ce bloc de code nous permet de sauvegarder les données de l'utilisateur en local utilisant une methode plus fiable que le UserDefault (codable method)
      //  let encoder = PropertyListEncoder()
//        do {
//            let data = try encoder.encode(itemArray) //on encode les données pour pouvoir les stocker de manière standard
//            try data.write(to: dataFilePath!)
//
//        } catch {
//            print("Error encoding item array \(error)")
//        }
        
    }
    
//    func loadItems() {
//        // Fonction qui va permettre de lire les données dans notre fichier de sauvegarde .plist
//
//        if let data = try? Data(contentsOf: dataFilePath!) {
//            let decoder = PropertyListDecoder()
//            do {
//            itemArray = try decoder.decode([Item].self, from: data)
//            } catch {
//                print("Error decoding item array, \(error)")
//            }
//
//        }
//    }

}

