//
//  BookInfoPersistable.swift
//  BookSearch
//
//  Created by Zaslavskiy Mike on 17/12/2019.
//  Copyright © 2019 MikeZaslavskiy. All rights reserved.
//

import RealmSwift

class BookInfoPersistable: Object {
    @objc dynamic var key: String = ""
    @objc dynamic var title: String = ""
    
    dynamic var firstYearOfPulish: Int? = 0
    dynamic var authors = List<String>()
    dynamic var isbn = List<String>()
    
    override static func primaryKey() -> String? {
        return "key"
    }
}
