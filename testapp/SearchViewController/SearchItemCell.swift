//
//  SearchItemCell.swift
//  testapp
//
//  Created by Dmitry Evglevsky on 28/01/2021.
//

import UIKit
import RealmSwift

class SearchItemCell: UITableViewCell {
    
    @IBOutlet weak var pictureView: UIImageView!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var trackLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    
    var item: CodableContentItem? {
        didSet {
            guard let item = item else { return }
            
            artistLabel.text = item.artistName
            trackLabel.text = item.trackName
            
            if let artwork = item.artworkUrl100, let url = URL(string: artwork) {
                pictureView.load(url: url)
            } else {
                pictureView.image = UIImage(named: "no_image")
            }
            
            let realmItem = item.convertToRealmItem()
            if DataService.shared.item(with: realmItem.uniqueKey) != nil {
                favoriteButton.isSelected = true
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        pictureView.image = nil
        favoriteButton.isSelected = false
    }
    
    @IBAction func favoriteAction(_ sender: UIButton) {
        guard let item = item else { return }
        let realmItem = item.convertToRealmItem()
        
        if let existingItem = DataService.shared.item(with: realmItem.uniqueKey) {
            DataService.shared.delete(existingItem)
            favoriteButton.isSelected = false
        } else {
            let itemWithImage = item.convertToRealmItem(pictureView.image)
            DataService.shared.save(itemWithImage)
            favoriteButton.isSelected = true
        }
    }
}
