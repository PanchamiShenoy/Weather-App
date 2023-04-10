//
//  WeatherDetailTableViewCell.swift
//  WeatherApp
//
//  Created by Panchami Shenoy on 08/02/22.
//

import UIKit

class WeatherDetailTableViewCell: UITableViewCell {
    @IBOutlet weak var keyLabel :UILabel!
    @IBOutlet weak var valueLabel :UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
