//
//  ProductCell.swift
//  novence
//
//  Created by Nico Cobelo on 01/12/2020.
//

import UIKit
import SwipeCellKit

class ProductCell: SwipeTableViewCell{

    @IBOutlet var productName: UILabel!
    @IBOutlet var expirationDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
