//
//  FavoritesItemCell.swift
//  testapp
//
//  Created by Dmitry Evglevsky on 28/01/2021.
//

import UIKit
import RealmSwift

class FavoritesItemCell: UITableViewCell {
    
    @IBOutlet weak var pictureView: UIImageView!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var trackLabel: UILabel!
    
    var item: FavoriteContentItem? {
        didSet {
            guard let item = item else { return }
            
            artistLabel.text = item.artistName
            trackLabel.text = item.trackName
            
            if let data = item.imageData {
                pictureView.image = UIImage(data: data)
            } else {
                pictureView.image = UIImage(named: "no_image")
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        pictureView.image = nil
    }
}
