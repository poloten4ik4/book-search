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
    
    var firstYearOfPulish: Int?
    var authors: List<String>?
    var isbn: List<String>?
    
    override static func primaryKey() -> String? {
        return "key"
    }
}
