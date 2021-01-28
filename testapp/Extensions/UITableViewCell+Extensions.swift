//
//  UITableViewCell+Extensions.swift
//  testapp
//
//  Created by Dmitry Evglevsky on 28/01/2021.
//

import UIKit

extension UITableViewCell {
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
}
