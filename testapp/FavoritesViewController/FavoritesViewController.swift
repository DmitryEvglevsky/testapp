//
//  FavoritesViewController.swift
//  testapp
//
//  Created by Dmitry Evglevsky on 28/01/2021.
//

import UIKit
import RealmSwift
import AVFoundation

class FavoritesViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let realm = try! Realm()
    var items = try! Realm().objects(FavoriteContentItem.self)
    var token: NotificationToken? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(FavoritesItemCell.nib, forCellReuseIdentifier: FavoritesItemCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView.init(frame: CGRect.zero)
        
        token = realm.observe { notification, realm in
            self.tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        items = try! Realm().objects(FavoriteContentItem.self)
        tableView.reloadData()
    }
    
    func showConfirmAlert(_ itemAtIndex: Int) {
        let alert = UIAlertController(title: "Warning", message: "Are you sure you want to delete this item?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
            self.realm.beginWrite()
            self.realm.delete(self.items[itemAtIndex])
            try! self.realm.commitWrite()
            self.playSound()
        })
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    func playSound() {
        let systemSoundID: SystemSoundID = 1152
        AudioServicesPlaySystemSound(systemSoundID)
    }
}

extension FavoritesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FavoritesItemCell.identifier) as? FavoritesItemCell else {
            return UITableViewCell()
        }
        let item = items[indexPath.row]
        cell.item = item
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { [weak self] (action, indexPath) in
            guard let self = self else { return }
            self.showConfirmAlert(indexPath.row)
        }

        return [delete]
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
}
