//
//  LocationCollectionViewCell.swift
//  WeatherApp
//
//  Created by Panchami Shenoy on 01/02/22.
//

import UIKit

class LocationCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var cityWeatherIcon: UIImageView!
    @IBOutlet weak var cityWeeather: UILabel!
    @IBOutlet weak var cityTemp: UILabel!
    @IBOutlet weak var cityTime: UILabel!
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var backgroundImage: UIImageView!
    let const = UiConstants()
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func awakeFromNib() {
        cityName.font = genericResizableFont(font: const.avenirBookBody)
        cityName.minimumScaleFactor = 0.1
        cityName.adjustsFontSizeToFitWidth = true

        cityTime.font = genericResizableFont(font: const.avenirBookBody )
        cityTime.minimumScaleFactor = 0.1
        cityTime.adjustsFontSizeToFitWidth = true
        
        cityTemp.font = genericResizableFont(font: const.avenirBookTitle)
        cityTemp.minimumScaleFactor = 0.1
        cityTemp.adjustsFontSizeToFitWidth = true
        
        cityWeeather.font = genericResizableFont(font: const.avenirBookBody)
        cityWeeather.minimumScaleFactor = 0.1
        cityWeeather.adjustsFontSizeToFitWidth = true
        
    }
   }



