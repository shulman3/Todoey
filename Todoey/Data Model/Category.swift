//
//  Category.swift
//  Todoey
//
//  Created by Victoria Shulman on 12/31/18.
//  Copyright © 2018 Victoria Shulman. All rights reserved.
//

import Foundation
import RealmSwift

class Category : Object {
    @objc dynamic var name : String = ""
    let items = List<Item>()
}
