//
//  SwipeTableViewController.swift
//  Todoey
//
//  Created by Tajgalt on 23/04/2021.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import UIKit
import SwipeCellKit

// On créé cette super classe afin de rendre compatible tous les UITableViewController avec les Cell qui peuvent être Swipe
class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 80.0 //permet de changer la taille du cell
        
    }
    
    
    //MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
       let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell //Cell = Un message. Cette ligne de code permet de créé un reusable cell
        // on downcast le cel en SwipeTableViewCell pour pouvoir profiter des fonctionnalité de la library qui permet de swiper une cell et proposer des actions
       cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil } // test l'orientation du swipe. S'il est vers la droite, ça va trigger l'action
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion
            
            
            self.updateModel(at: indexPath)
            
            
            // Ligne de code qui nous permet de supprimer une categorie
//            if let categoryForDeletion = self.categoryArray?[indexPath.row] {
//
//                do {
//                    try self.realm.write {
//
//                        self.realm.delete(categoryForDeletion)
//                    }
//
//                } catch {
//                    print("Error saving context, \(error)")
//
//                }
//
//                tableView.reloadData()
//            }
        }
        
        // customize the action appearance with the icon we want
        deleteAction.image = UIImage(named: "delete-icon")
        
        return [deleteAction]
    }
    
    
    // Théoriquement cette fonction permet de swipe complétement pour supprimer la category
    func collectionView(_ collectionView: UICollectionView, editActionsOptionsForItemAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        return options
    }

    @objc dynamic func updateModel(at indexPath: IndexPath){
        //Update our data model
    }
    
}

 
