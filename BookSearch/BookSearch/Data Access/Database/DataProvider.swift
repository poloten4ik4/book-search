//
//  DataProvider.swift
//  BookSearch
//
//  Created by Zaslavskiy Mike on 17/12/2019.
//  Copyright © 2019 MikeZaslavskiy. All rights reserved.
//

import Realm
import RealmSwift

class DataProvider {
    func objects<T: Object>(_ type: T.Type, predicate: NSPredicate? = nil) -> Results<T>? {
        if !isRealmAccessible() { return nil }

        let realm = try! Realm()
        realm.refresh()

        return predicate == nil ? realm.objects(type) : realm.objects(type).filter(predicate!)
    }

    func object<T: Object>(_ type: T.Type, key: String) -> T? {
        if !isRealmAccessible() { return nil }

        let realm = try! Realm()
        realm.refresh()

        return realm.object(ofType: type, forPrimaryKey: key)
    }

    func add<T: Object>(_ data: [T], update: Bool = true) {
        if !isRealmAccessible() { return }

        let realm = try! Realm()
        realm.refresh()

        if realm.isInWriteTransaction {
            realm.add(data, update: update ? .all : .error)
        } else {
            // TODO: Need to handle write transaction failure.
            // Write transactions could potentially fail like any other disk IO operations
            try? realm.write {
                realm.add(data, update: update ? .all : .error)
            }
        }
    }

    func add<T: Object>(_ data: T, update: Bool = true) {
        add([data], update: update)
    }

    func runTransaction(action: () -> Void) {
        if !isRealmAccessible() { return }

        let realm = try! Realm()
        realm.refresh()

        // TODO: Need to handle write transaction failure.
        // Write transactions could potentially fail like any other disk IO operations
        try? realm.write {
            action()
        }
    }

    func delete<T: Object>(_ data: [T]) {
        let realm = try! Realm()
        realm.refresh()
        // TODO: Need to handle write transaction failure.
        // Write transactions could potentially fail like any other disk IO operations
        try? realm.write { realm.delete(data) }
    }

    func delete<T: Object>(_ data: T) {
        delete([data])
    }

    func clearAllData() {
        if !isRealmAccessible() { return }

        let realm = try! Realm()
        realm.refresh()
        // TODO: Need to handle write transaction failure.
        // Write transactions could potentially fail like any other disk IO operations
        try? realm.write { realm.deleteAll() }
    }
}

extension DataProvider {
    func isRealmAccessible() -> Bool {
        do { _ = try Realm() } catch {
            print("Realm is not accessible")
            return false
        }
        return true
    }

    func configureRealm() {
        let config = RLMRealmConfiguration.default()
        config.deleteRealmIfMigrationNeeded = true
        RLMRealmConfiguration.setDefault(config)
    }
}
