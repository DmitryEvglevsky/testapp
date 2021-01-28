//
//  SearchViewModel.swift
//  testapp
//
//  Created by Dmitry Evglevsky on 28/01/2021.
//

import UIKit
import Foundation

class SearchViewModel: NSObject, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate {
    
    private var items: [CodableContentItem] = []
    
    var isEmpty: Bool { return items.count == 0 }
    var reloadViewClosure: (() -> (Void))?
    
    func fetchData() {
        let searchText = UserSettings.shared.searchText
        let searchType = UserSettings.shared.searchType
        WebService.shared.loadItems(searchText, searchType) { [weak self] (items) in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.items = items ?? []
                self.reloadViewClosure?()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchItemCell.identifier) as? SearchItemCell else {
            return UITableViewCell()
        }
        let item = items[indexPath.row]
        cell.item = item
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120.0
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        UserSettings.shared.searchText = searchText
        fetchData()
    }
}
