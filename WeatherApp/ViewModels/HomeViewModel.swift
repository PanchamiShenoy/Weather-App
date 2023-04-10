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
    
    func getCityList() {
        var locManager = CLLocationManager()
        locManager.requestWhenInUseAuthorization()
        
        var currentLocation: CLLocation!
        
        if
            CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
                CLLocationManager.authorizationStatus() ==  .authorizedAlways
        {
            currentLocation = CLLocationManager().location
            currentLocation.fetchCityAndCountry { city, country, error in
                self.cityList.append(city ?? "Bangalore")
            }
        }
    }
    
}

extension CLLocation {
    func fetchCityAndCountry(completion: @escaping (_ city: String?, _ country:  String?, _ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(self) { completion($0?.first?.locality, $0?.first?.country, $1) }
    }
}
