//
//  WeatherDetailViewController.swift
//  WeatherApp
//
//  Created by Panchami Shenoy on 03/02/22.
//

import UIKit
import FirebaseAuth
class WeatherDetailViewController: UIViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak private var tableView :UITableView!
    
    @IBOutlet weak private var backgroundImage: UIImageView!
    
    @IBOutlet weak private var cityNameLabel: UILabel!
    
    @IBOutlet weak private var timeAndWeatherCondition: UILabel!
    
    @IBOutlet weak private var weatherConnditionIcon: UIImageView!
    @IBOutlet weak private var temperature: UILabel!
    @IBOutlet weak private var bookmarked: UIButton!
    
    var viewModel = WeatherDetailViewModel()
    var favLocation = [String: Any]()
    var favLocations = [FavLocationDetail]()
    var city: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = .white
        fetchFavLocation()
        fetchCityWeatherDetail()
        navigationBarSetUp()
        activityIndicator.startAnimating()
        tableViewSetUp()
        addAccessibility()
    }
    
    
    func tableViewSetUp() {
        tableView.delegate = self
        tableView.dataSource = self
        let nib = UINib(nibName: "WeatherDetailTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "WeatherDetailTableViewCell")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        tableView.scrollIndicatorInsets = UIEdgeInsets(top: 0,left: 0,bottom: 0,right: tableView.bounds.size.width - 10);
    }
    
    func setUpUi() {
        guard let validWeatherDetail = viewModel.weatherDetails else {
            return
        }
        let hr = getHr(timeZone:  validWeatherDetail.timezone)
        guard let hour = Int(hr) else {
            return
        }
        let amOrPm = getAmOrPm(timeZone: validWeatherDetail.timezone)
        let timeInHrMin = getTimeInHrMin(timeZone:validWeatherDetail.timezone)
        cityNameLabel.text = validWeatherDetail.name
        temperature.text = "\(fahrenheitToCelsius(temperature: validWeatherDetail.main.temp))\(UnicodeConstants.degree.rawValue)"
        timeAndWeatherCondition.text = "\(validWeatherDetail.weather[0].main), \(timeInHrMin)"
        weatherConnditionIcon.image = getWeatherConditionIcon(weather: (validWeatherDetail.weather[0].main) )
        backgroundImage.image = getBackgroundImage(amOrPm: amOrPm, hour: hour, weatherCondition: (validWeatherDetail.weather[0].main))
    }
    
    func navigationBarSetUp() {
        navigationController?.navigationBar.backIndicatorImage = UIImage(systemName: ImageSystemName.backButtonImage.rawValue)
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(systemName: ImageSystemName.backButtonImage.rawValue)
    }
    
    func getBackgroundImage(amOrPm : String ,hour:Int, weatherCondition: String) -> UIImage {
        if (amOrPm == TimeStringConstants.am.rawValue &&  hour >= TimeNumberConstants.six.rawValue ) || (amOrPm == TimeStringConstants.pm.rawValue &&  (hour <= TimeNumberConstants.six.rawValue || hour == TimeNumberConstants.twelve.rawValue) ) {
            switch weatherCondition {
            case WeatherCondition.clouds.rawValue:
                return UIImage(named: ImageAssetName.cloudyDay.rawValue) ?? UIImage()
            case WeatherCondition.clear.rawValue:
                return UIImage(named: ImageAssetName.clearDay.rawValue) ?? UIImage()
            case WeatherCondition.smoke.rawValue:
                return UIImage(named: ImageAssetName.cloudyDay.rawValue) ?? UIImage()
            case WeatherCondition.haze.rawValue:
                return UIImage(named: ImageAssetName.hazeDay.rawValue) ?? UIImage()
            case WeatherCondition.mist.rawValue:
                return UIImage(named: ImageAssetName.hazeDay.rawValue) ?? UIImage()
            case WeatherCondition.rain.rawValue:
                return UIImage(named: ImageAssetName.rainyDay.rawValue) ?? UIImage()
            default :
                return UIImage()
            }
            
        }else {
            switch weatherCondition {
            case WeatherCondition.clouds.rawValue:
                return UIImage(named: ImageAssetName.cloudyNight.rawValue) ?? UIImage()
            case WeatherCondition.clear.rawValue:
                return UIImage(named: ImageAssetName.clearNight.rawValue) ?? UIImage()
            case WeatherCondition.rain.rawValue:
                return UIImage(named: ImageAssetName.rainyDay.rawValue) ?? UIImage()
            case WeatherCondition.haze.rawValue:
                return UIImage(named: ImageAssetName.hazeNight.rawValue) ?? UIImage()
            case WeatherCondition.mist.rawValue:
                return UIImage(named: ImageAssetName.hazeNight.rawValue) ?? UIImage()
            default :
                return  UIImage()
            }
            
        }
    }
    
    @IBAction func clickedBack(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    func addAccessibility() {
        navigationController?.navigationItem.accessibilityHint = AccessibilityConsts.doubletTapHint.rawValue
        navigationItem.backBarButtonItem?.accessibilityHint = AccessibilityConsts.doubletTapHint.rawValue
        bookmarked.accessibilityLabel = AccessibilityConsts.bookMarkLabel.rawValue
        bookmarked.accessibilityHint = AccessibilityConsts.doubletTapHint.rawValue
    }
}
//MARK: Tableview delegate and data source methods
extension WeatherDetailViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = viewModel.weatherDetailValues.count
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherDetailTableViewCell",for: indexPath) as? WeatherDetailTableViewCell else{
            return UITableViewCell()
        }
        cell.keyLabel.text = viewModel.weatherDetailsKeys[indexPath.row]
        cell.valueLabel.text = viewModel.weatherDetailValues[indexPath.row]
        return cell
    }
    
}

//MARK: Api call
extension WeatherDetailViewController{
    
    func fetchCityWeatherDetail() {
        guard let cityToBeSearched = city else{
            return
        }
        viewModel.fetchDataWithCityName(city:cityToBeSearched, completionHandler: { [weak self]  in
            guard let validWeatherDetail = self?.viewModel.weatherDetails else {
                return
            }
            DispatchQueue.main.async {
                self?.tableView.reloadData()
                self?.setUpUi()
                self?.activityIndicator.stopAnimating()
            }
        })
        
    }
    
    @IBAction func onSave(_ sender: Any) {
        favLocation = ["location": city]
        NetworkManager().fetchFavLocatiom { locations in
            self.favLocations = locations
            for location in self.favLocations {
                if location.location == self.city {
                    NetworkManager().deleteFavLocation(location: self.favLocations.filter({$0.location == self.city}).first ?? FavLocationDetail(documentid: "", location: ""))
                    self.bookmarked.setImage(UIImage(systemName: "bookmark"), for: .normal)
                    return
                }
            }
            NetworkManager().addFavLocation(location: self.favLocation, uid: Auth.auth().currentUser?.uid ?? "")
            self.bookmarked.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
        }
    }
    
    func fetchFavLocation() {
        NetworkManager().fetchFavLocatiom { locations in
            self.favLocations = locations
            for location in self.favLocations {
                if location.location == self.city {
                    self.bookmarked.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
                    return
                }
            }
            self.bookmarked.setImage(UIImage(systemName: "bookmark"), for: .normal)
        }
    }
}

enum AccessibilityConsts: String {
    case backButtonLabel = "Back button"
    case doubletTapHint = "Double tap to activate"
    case bookMarkLabel = "Save City"
}
