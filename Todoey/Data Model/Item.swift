//
//  Item.swift
//  Todoey
//
//  Created by Victoria Shulman on 12/31/18.
//  Copyright © 2018 Victoria Shulman. All rights reserved.
//

import Foundation
import RealmSwift

class Item : Object {
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    @objc dynamic var dateCreated : Date?
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
