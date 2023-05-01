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
    var city: String?
    var favLocations = [FavLocationDetail]()
    let consts = UiConstants()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = .white
        navigationBarSetUp()
        fetchFavLocation()
        fetchCityWeatherDetail()
        navigationBarSetUp()
        activityIndicator.startAnimating()
        tableViewSetUp()
        addAccessibility()
    }
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if previousTraitCollection?.preferredContentSizeCategory != traitCollection.preferredContentSizeCategory {
            setUpUi()
        }
    }
    
    func tableViewSetUp() {
        tableView.delegate = self
        tableView.dataSource = self
        let nib = UINib(nibName: CellIdentifier.WeatherDetailTableViewCell.rawValue, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: CellIdentifier.WeatherDetailTableViewCell.rawValue)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }

    func setUpUi() {
       
        cityNameLabel.font = genericResizableFont(font: consts.avenirBookBody)
        temperature.font = genericResizableFont(font: consts.avenirBookTitle)
        timeAndWeatherCondition.font = genericResizableFont(font: consts.avenirBookBody)
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
        let button = UIBarButtonItem(image: UIImage(systemName: ImageSystemName.bookmark.rawValue), style: .done, target: self, action: #selector(onSave(sender: )))
        self.navigationItem.rightBarButtonItem = button
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
        navigationController?.navigationItem.accessibilityHint = AccessibilityConstants.doubleTapToActive.rawValue
        navigationItem.backBarButtonItem?.accessibilityHint = AccessibilityConstants.doubleTapToActive.rawValue
        self.navigationItem.rightBarButtonItem?.accessibilityLabel = WeatherDetailAccessibilityConstants.bookMarkLabel.rawValue
        self.navigationItem.rightBarButtonItem?.accessibilityHint = AccessibilityConstants.doubleTapToActive.rawValue
    }
}

//MARK: Tableview delegate and data source methods
extension WeatherDetailViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = viewModel.weatherDetailValues.count
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.WeatherDetailTableViewCell.rawValue,for: indexPath) as? WeatherDetailTableViewCell else{
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
            DispatchQueue.main.async {
                self?.tableView.reloadData()
                self?.setUpUi()
                self?.activityIndicator.stopAnimating()
            }
        })
        
    }
    
    @objc func onSave(sender: UIBarButtonItem) {
        viewModel.favLocation = ["location": city]
            for location in self.viewModel.favLocations {
                if location.location == self.city {
                    viewModel.deleteLocation(city: city ?? "")
                    fetchFavLocation()
                    return
                }
            }
            viewModel.saveLocation()
            fetchFavLocation()
    }
    
    func fetchFavLocation() {
        viewModel.fetchFavLocation { 
            for location in self.viewModel.favLocations {
                if location.location == self.city {
                    self.navigationItem.rightBarButtonItem?.image = UIImage(systemName: ImageSystemName.bookmarkFill.rawValue)
                    return
                }
            }
            self.navigationItem.rightBarButtonItem?.image = UIImage(systemName: ImageSystemName.bookmark.rawValue)
        }
    }
}

enum WeatherDetailAccessibilityConstants: String {
    case backButtonLabel = "Back button"
    case bookMarkLabel = "Save City"
}
