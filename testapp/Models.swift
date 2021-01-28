//
//  Models.swift
//  testapp
//
//  Created by Dmitry Evglevsky on 28/01/2021.
//

import Foundation
import RealmSwift

class ContentResult: Codable {
    var results: [CodableContentItem]?
    var resultCount: Int?
}

class CodableContentItem: Codable {
    public var wrapperType: String?
    public var kind: String?
    public var entity: String?
    public var trackId: Int?
    public var artistName: String?
    public var trackName: String?
    public var artworkUrl100: String?
}

class FavoriteContentItem: Object {
    @objc dynamic var wrapperType: String = ""
    @objc dynamic var kind: String = ""
    @objc dynamic var entity: String = ""
    @objc dynamic var trackId: Int = 0
    @objc dynamic var artistName: String = ""
    @objc dynamic var trackName: String = ""
    @objc dynamic var artworkUrl100: String = ""
    @objc dynamic var uniqueKey: String = ""
    @objc dynamic var imageData: Data?
    override static func primaryKey() -> String? {
        return "uniqueKey"
    }
}

extension CodableContentItem {
    func convertToRealmItem(_ image: UIImage? = nil) -> FavoriteContentItem {
        let item = FavoriteContentItem()
        item.artistName = artistName ?? "N/A"
        item.trackName = trackName ?? "N/A"
        item.wrapperType = wrapperType ?? "N/A"
        item.entity = entity ?? "N/A"
        item.trackId = trackId ?? 0
        item.artworkUrl100 = artworkUrl100 ?? ""
        // Trick, because itunes content item doesn't have any unique id, and API can return empty fields.
        if artworkUrl100 != nil {
            item.uniqueKey = item.artworkUrl100
        } else {
            item.uniqueKey = item.artistName + " - " + item.trackName + " - \(item.trackId)"
        }
        if let image = image {
            item.imageData = UIImage.covertToGrayscale(image: image)?.pngData()
        }
        return item
    }
}
