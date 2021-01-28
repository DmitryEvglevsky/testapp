//
//  DataService.swift
//  testapp
//
//  Created by Dmitry Evglevsky on 28/01/2021.
//

import Foundation
import RealmSwift

final class DataService {
    static var shared = DataService()
    
    func item(with uniqueKey: String) -> FavoriteContentItem? {
        let realm = try! Realm()
        let items = realm.objects(FavoriteContentItem.self).filter("uniqueKey == '\(uniqueKey)'")
        return items.first
    }

    func save(_ item: FavoriteContentItem) {
        let realm = try! Realm()
        try! realm.write {
            realm.add(item, update: .modified)
        }
    }
    
    func delete(_ item: FavoriteContentItem) {
        let realm = try! Realm()
        try! realm.write {
            realm.delete(item)
        }
    }

    func fetchFavorites() -> [FavoriteContentItem] {
        let realm = try! Realm()
        return Array(realm.objects(FavoriteContentItem.self))
    }
}
