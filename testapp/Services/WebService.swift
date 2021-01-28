//
//  WebService.swift
//  testapp
//
//  Created by Dmitry Evglevsky on 28/01/2021.
//

import Foundation

final class WebService {
    static var shared = WebService()
    
    private let itemsLimit = 25
    private let baseHost = "https://itunes.apple.com/search"
    
    func loadItems(_ term: String, _ type: ContentSearchType, completion: @escaping (_ items: [CodableContentItem]?) -> Void)  {
        let urlString = "\(baseHost)?term=\(term)&media=\(type)&limit=\(itemsLimit)"
        guard let url = URL(string: urlString) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                completion(nil)
                return
            }
            let decoder = JSONDecoder()
            guard let contentResult = try? decoder.decode(ContentResult.self, from: data) else {
                completion(nil)
                return
            }
            guard let items = contentResult.results else {
                completion(nil)
                return
            }
            completion(items)
        }
        task.resume()
    }
}
