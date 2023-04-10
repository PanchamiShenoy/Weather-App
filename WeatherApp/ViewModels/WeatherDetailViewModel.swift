
//  weatherDetailViewModel.swift
//  WeatherApp
//
//  Created by Panchami Shenoy on 03/02/22.


import Foundation

class WeatherDetailViewModel {
    var weatherDetails: WeatherResults?
    let weatherDetailsKeys = [WeatherDetailKey.feelsLike.rawValue, WeatherDetailKey.pressure.rawValue,WeatherDetailKey.humidity.rawValue, WeatherDetailKey.visibilty.rawValue, WeatherDetailKey.windSpeed.rawValue, WeatherDetailKey.clouds.rawValue, WeatherDetailKey.dewPoint.rawValue, WeatherDetailKey.uvi.rawValue]
    var weatherDetailValues = [String]()
    
    func fetchDataWithCityName(city: String, completionHandler: @escaping ()->Void ){
        NetworkManager().getDataWithCityName(city:city,completionHandler:{ [weak self] (weatherResults,errorReceived) in
            self?.weatherDetails = weatherResults
            guard let validWeatherDetails = self?.weatherDetails else {
                return
            }
            self?.weatherDetailValues.append("\(validWeatherDetails.main.feelsLike)")
            self?.weatherDetailValues.append("\(validWeatherDetails.main.pressure)")
            self?.weatherDetailValues.append("\(validWeatherDetails.main.humidity)")
            self?.weatherDetailValues.append("\(validWeatherDetails.visibility)")
            self?.weatherDetailValues.append("\(validWeatherDetails.wind.speed)")
            completionHandler()
        })
        
    }
}
