
//  weatherDetailViewModel.swift
//  WeatherApp
//
//  Created by Panchami Shenoy on 03/02/22.


import Foundation
import FirebaseAuth

class WeatherDetailViewModel {
    var weatherDetails: WeatherResults?
    var favLocations = [FavLocationDetail]()
    var favLocation = [String: Any]()
    
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
    
    func saveLocation() {
        NetworkManager().addFavLocation(location: favLocation, uid: Auth.auth().currentUser?.uid ?? "")
        
    }
    
    func deleteLocation(city: String) {
        NetworkManager().deleteFavLocation(location: favLocations.filter({$0.location == city}).first ?? FavLocationDetail(documentid: "", location: ""))
    }
    
    func fetchFavLocation(completionHandler: @escaping()->Void ) {
        NetworkManager().fetchFavLocatiom { [weak self] locations in
            self?.favLocations = locations
            completionHandler()
            //completionHandler(locations)
        }
    }
}
