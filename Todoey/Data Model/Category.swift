//
//  Category.swift
//  Todoey
//
//  Created by Ahmad Osman on 6/6/19.
//  Copyright © 2019 Mido Apps. All rights reserved.
//

import Foundation
import RealmSwift


class Category: Object {
    @objc dynamic var name : String = ""
    @objc dynamic var color : String = ""
    let items = List<Item>()
}
