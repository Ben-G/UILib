//
//  UserCell.swift
//  UILib
//
//  Created by Benji Encz on 5/4/16.
//  Copyright © 2016 Benjamin Encz. All rights reserved.
//

import UIKit

class UserCell: UITableViewCell {

    @IBOutlet var nameLabel: UILabel!

}


func applyViewModelUserCell(_ user: String) -> (_ cell: UITableViewCell) -> Void {
    return { cell in
        guard let cell = cell as? UserCell else { return }
        cell.nameLabel.text = user
    }
}
