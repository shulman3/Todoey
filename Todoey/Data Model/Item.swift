//
//  Item.swift
//  Todoey
//
//  Created by Victoria Shulman on 12/27/18.
//  Copyright © 2018 Victoria Shulman. All rights reserved.
//

import Foundation
class Item: Encodable, Decodable{
    var title : String = ""
    var done : Bool = false
}
