//
//  Item.swift
//  Todoey
//
//  Created by Tajgalt on 18/04/2021.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

// Pour porfiter de la base de donnée Realm, il faut annoncer le protocole Object
class Item: Object {
    @objc dynamic var title: String = "" //Dynamic key word permet à Realm de mettre à jour sa base de données de manière dynamique loirsque l'utilisateur change la valeur. Il est essentiel d'instancier ces var ainsi pour utiliser la base de donné Realm
   @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items") //On créé le lien de cette classe avec la classe category. Ce lien signifie que un Item ne peut être associé qu'à une seul category à laquelle elle appartient
    
    
}
