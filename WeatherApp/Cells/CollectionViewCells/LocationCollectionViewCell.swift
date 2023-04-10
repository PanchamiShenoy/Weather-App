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
        cityName.adjustsFontForContentSizeCategory = true
        cityTime.adjustsFontForContentSizeCategory = true
        cityTemp.adjustsFontForContentSizeCategory = true
        cityWeeather.adjustsFontForContentSizeCategory = true
        cityName.font = genericResizableFont(font: const.cityNameFont)
        cityTime.font = genericResizableFont(font: const.cityTimeFont)
        cityTemp.font = genericResizableFont(font: const.cityTempFont)
        cityWeeather.font = genericResizableFont(font: const.cityWeatherFont)
        
    }
   }

struct UiConstants {
    let cityNameFont = UIFont(name:"Avenir Book", size: 20.0)
    let cityTempFont = UIFont(name: "Avenir Book",size: 25.0)
    let cityTimeFont = UIFont(name: "Avenir Book",size: 20.0)
    let cityWeatherFont = UIFont(name: "Avenir Book", size: 20.0)
}

