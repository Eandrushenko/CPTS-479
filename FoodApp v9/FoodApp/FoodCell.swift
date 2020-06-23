//
//  FoodCell.swift
//  FoodApp
//
//  Created by Elijah Andrushenko on 2/19/20.
//  Copyright © 2020 Elijah Andrushenko. All rights reserved.
//

import UIKit

class FoodCell: UITableViewCell {

    @IBOutlet weak var FoodImage: UIImageView!
    @IBOutlet weak var FoodName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
