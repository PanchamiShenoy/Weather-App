//
//  HomeViewModel.swift
//  WeatherApp
//
//  Created by Panchami Shenoy on 02/02/22.
//

import Foundation
import MapKit

class HomeViewModel {
    var cityList = [String]()
    var locationList =  [WeatherResults]()
    var favLocations = [FavLocationDetail]()
    var height: CGFloat = 0.0
    func fetchData(city:String, completionHandler: @escaping (Error?)-> Void ) {
        
        NetworkManager().getDataWithCityName(city:city, completionHandler:{ [weak self] (weatherResults,errorReceieved) in
            if let errorReceieved = errorReceieved  {
                completionHandler(errorReceieved)
                return
            }
            guard let weatherResults = weatherResults else {
                return
            }
            self?.locationList.append(weatherResults)
            completionHandler(nil)
        })
        
    }
    
    func fetchFavLocation(completionHandler: @escaping([FavLocationDetail])->Void ) {
        NetworkManager().fetchFavLocatiom { [weak self] locations in
            self?.favLocations = locations
            completionHandler(locations)
        }
    }
    
    
}

extension CLLocation {
    func fetchCityAndCountry(completion: @escaping (_ city: String?, _ country:  String?, _ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(self) { completion($0?.first?.locality, $0?.first?.country, $1) }
    }
}
