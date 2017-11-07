//
//  mycellTableViewCell.swift
//  DRVA
//
//  Created by Sarvesh on 6/21/17.
//  Copyright © 2017 Sarvesh. All rights reserved.
//

import UIKit

class mycellTableViewCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var age: UILabel!
    @IBOutlet weak var uid: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
