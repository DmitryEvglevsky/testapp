//
//  SearchViewController.swift
//  testapp
//
//  Created by Dmitry Evglevsky on 27/01/2021.
//

import UIKit
import RealmSwift

class SearchViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    private var viewModel = SearchViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(SearchItemCell.nib, forCellReuseIdentifier: SearchItemCell.identifier)
        tableView.delegate = viewModel
        tableView.dataSource = viewModel
        tableView.tableFooterView = UIView.init(frame: CGRect.zero)
        
        searchBar.delegate = viewModel
        
        searchBar.text = UserSettings.shared.searchText
        viewModel.fetchData()
        
        viewModel.reloadViewClosure = { [weak self] in
            guard let self = self else { return }
            self.tableView.isHidden = self.viewModel.isEmpty
            self.tableView.reloadSections(IndexSet(integer: 0), with: .fade)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }
    
    @IBAction func changeSearchTypeAction(_ sender: UIButton) {
        let actionSheet = UIAlertController(title: nil, message: "Select media type", preferredStyle: .actionSheet)
        
        let currentType = UserSettings.shared.searchType
        for type in ContentSearchType.allCases {
            let action = UIAlertAction(title: type.rawValue, style: .default) { [weak self] _ in
                UserSettings.shared.searchType = type
                self?.viewModel.fetchData()
            }
            if type == currentType {
                action.setValue(true, forKey: "checked")
            }
            actionSheet.addAction(action)
        }
        
        actionSheet.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        present(actionSheet, animated: true, completion: nil)
    }
}

