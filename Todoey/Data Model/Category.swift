//
//  Category.swift
//  Todoey
//
//  Created by Arturo Lee on 1/9/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var hexValue: String = ""
    let items = List<Item>()
}
