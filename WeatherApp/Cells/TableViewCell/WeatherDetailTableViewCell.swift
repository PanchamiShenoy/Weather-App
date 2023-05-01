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
    let consts = UiConstants()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        keyLabel.font = genericResizableFont(font: consts.avenirBookBody)
        valueLabel.font = genericResizableFont(font: consts.avenirBookBody)
        keyLabel.minimumScaleFactor = 0.1
        keyLabel.adjustsFontSizeToFitWidth = true
        valueLabel.minimumScaleFactor = 0.1
        valueLabel.adjustsFontSizeToFitWidth = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
