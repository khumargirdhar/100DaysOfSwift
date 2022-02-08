//
//  countryCell.swift
//  COUNTRY-FACTS
//
//  Created by Khumar Girdhar on 07/10/21.
//

import UIKit

class countryCell: UITableViewCell {
    @IBOutlet var flagImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
