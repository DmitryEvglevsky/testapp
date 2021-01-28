//
//  UserSettings.swift
//  testapp
//
//  Created by Dmitry Evglevsky on 28/01/2021.
//

import Foundation

struct Constants {
    static let kSearchTextKey = "kSearchTextKey"
    static let kSearchTypeKey = "kSearchTypeKey"
}

enum ContentSearchType: String, CaseIterable {
    case movie, podcast, music, musicVideo, audiobook,
         shortFilm, tvShow, software, ebook, all
}

final class UserSettings {
    static var shared = UserSettings()
    
    var searchText: String {
        get {
            guard let searchText = UserDefaults.standard.value(forKey: Constants.kSearchTextKey) as? String else {
               return ""
            }
            return searchText
        }
        set (searchText) {
           UserDefaults.standard.set(searchText, forKey: Constants.kSearchTextKey)
        }
    }
    
    var searchType: ContentSearchType {
        get {
            guard let searchType = UserDefaults.standard.value(forKey: Constants.kSearchTypeKey) as? String else {
                return .movie
            }
            return ContentSearchType(rawValue: searchType) ?? .movie
        }
        set (searchType) {
            UserDefaults.standard.set(searchType.rawValue, forKey: Constants.kSearchTypeKey)
        }
    }
}
