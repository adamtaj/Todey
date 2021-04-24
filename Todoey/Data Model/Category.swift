//
//  Category.swift
//  Todoey
//
//  Created by Tajgalt on 18/04/2021.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object { // Object class allow us to save data in the realm
    @objc dynamic var name: String = ""
    @objc dynamic var backgroundColor: String = "1D9BF6"
    let items = List<Item>() //Permet de créé une relation avec la class / entité Item en tant que multi-realtion. Cela veut dire qu'un category peut contenir plusieurs items
}
