//
//  ViewController.swift
//  WeatherApp
//
//  Created by Panchami Shenoy on 01/02/22.
//

import UIKit
import MapKit
import FirebaseAuth
import GooglePlaces
class HomeViewController: UIViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak private var locationCollectionView: UICollectionView!
    @IBOutlet weak private var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var signOutButton: UIButton!
    @IBOutlet weak var locationCollectionViewHeight: NSLayoutConstraint!
    private var tableDataSource: GMSAutocompleteTableDataSource!
    var viewModel = HomeViewModel()
    var isPotrait: Bool = true
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        activityIndicator.startAnimating()
        setUpDelegates()
        addAccessibilities()
        tableViewSetup()
        searchbarSetup()
        checkOrientation()
        NotificationCenter.default.addObserver(self, selector: #selector(self.checkOrientation), name: UIDevice.orientationDidChangeNotification, object: nil)
        
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if previousTraitCollection?.preferredContentSizeCategory != traitCollection.preferredContentSizeCategory {
            locationCollectionView.reloadData()
        }
    }
    
    @objc func checkOrientation() {
        if UIDevice.current.orientation.isLandscape {
            isPotrait = false
            locationCollectionView.reloadData()
        } else {
            isPotrait = true
            locationCollectionView.reloadData()
        }
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    func setUpDelegates() {
        locationCollectionView.dataSource = self
        locationCollectionView.delegate = self
        searchBar.delegate = self
    }
    
    func searchbarSetup() {
        searchBar.searchBarStyle = .minimal
        searchBar.backgroundColor = .white.withAlphaComponent(0.1)
        searchBar.placeholder = HomeConstants.search.rawValue
        if let textfield = searchBar.value(forKey: "searchField") as? UITextField {
            textfield.textColor = .white
            textfield.backgroundColor = .black.withAlphaComponent(0.5)
            textfield.attributedPlaceholder = NSAttributedString(
                string: HomeConstants.search.rawValue,
                attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.5)]
            )
        }
    }
    
    func tableViewSetup() {
        tableDataSource = GMSAutocompleteTableDataSource()
        tableDataSource.delegate = self
        tableView.isHidden = true
        tableView.delegate = tableDataSource
        tableView.dataSource = tableDataSource
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fillData()
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func getBackgroundImage(city: String)-> UIImage {
        return UIImage(named: ImageAssetName.cloudyDay.rawValue) ?? UIImage()
    }
    
    func replaceSpace(text: String)-> String {
        return text.replacingOccurrences(of: " ", with: "+")
    }
    
    func transitionToSignIn() {
        let vc = storyboard?.instantiateViewController(withIdentifier: VcIdentifier.signinVC.rawValue)
        view.window?.rootViewController = vc
        view.window?.makeKeyAndVisible()
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
        tableView.isHidden = true
    }
    
    @IBAction func onSignout(_ sender: Any) {
        NetworkManager().signOut()
        transitionToSignIn()
    }
    
    func addAccessibilities() {
        signOutButton.isAccessibilityElement = true
        signOutButton.accessibilityHint = AccessibilityConstants.doubleTapToActive.rawValue
        signOutButton.accessibilityLabel = HomeAccessibilityConstants.signoutButtonAccessibilityLabel.rawValue
        searchBar.isAccessibilityElement = true
        searchBar.accessibilityLabel = HomeAccessibilityConstants.searchBarAccessibilityLabel.rawValue
        searchBar.accessibilityHint = AccessibilityConstants.doubleTapToActive.rawValue
    }
}

//MARK: UICollection view delegate and data source methods
extension HomeViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.locationList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard  let cell = locationCollectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier.locationCell.rawValue, for: indexPath) as? LocationCollectionViewCell else{
            return UICollectionViewCell()
        }
        cell.cityName.text = viewModel.locationList[indexPath.row].name
        cell.cityTime.text = getTimeInHrMin(timeZone:viewModel.locationList[indexPath.row].timezone)
        cell.cityTemp.text = "\(fahrenheitToCelsius(temperature: viewModel.locationList[indexPath.row].main.temp))\(UnicodeConstants.degree.rawValue)"
        cell.cityWeeather.text = viewModel.locationList[indexPath.row].weather[0].main
        cell.cityWeatherIcon.image = getWeatherConditionIcon(weather:"\(viewModel.locationList[indexPath.row].weather[0].main)")
        cell.backgroundImage.image = getBackgroundImage(city: viewModel.locationList[indexPath.row].name)
        cell.contentView.layer.cornerRadius = CollectionViewSizeConstants.cornerRadius.rawValue
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var width: CGFloat = 0
        if isPotrait == false {
            width    = (self.view.safeAreaLayoutGuide.layoutFrame.width-CollectionViewSizeConstants.allignmentSpacing.rawValue - 30)/3
        }
        else {
            width = (self.view.safeAreaLayoutGuide.layoutFrame.width-CollectionViewSizeConstants.allignmentSpacing.rawValue - 20 )/2
        }
        
        viewModel.height = 150.0
        let const = UiConstants()
        
        viewModel.height += genericResizableFont(font: const.avenirBookBody).lineHeight
        viewModel.height += genericResizableFont(font: const.avenirBookBody).lineHeight
        viewModel.height += genericResizableFont(font: const.avenirBookBody).lineHeight
        viewModel.height += genericResizableFont(font: const.avenirBookTitle).lineHeight
        locationCollectionViewHeight.constant = viewModel.height
        return CGSize(width: width , height: viewModel.height)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CollectionViewSizeConstants.interItemSpacing.rawValue
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = UIStoryboard.init(name: HomeConstants.main.rawValue, bundle:Bundle.main).instantiateViewController(withIdentifier: VcIdentifier.weatherDetailVC.rawValue) as? WeatherDetailViewController
        vc?.city = replaceSpace(text:viewModel.locationList[indexPath.row].name)
        vc?.viewModel.favLocations = viewModel.favLocations
        guard let viewController = vc else {
            return
        }
        navigationController?.pushViewController(viewController, animated: true)
    }
}

extension HomeViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        tableView.isHidden = false
        if searchText == "" {
            tableView.isHidden = true
            return
        }
        tableDataSource.sourceTextHasChanged(searchText)
    }
    
}

extension HomeViewController: GMSAutocompleteTableDataSourceDelegate {
    func didUpdateAutocompletePredictions(for tableDataSource: GMSAutocompleteTableDataSource) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        tableView.reloadData()
    }
    
    func didRequestAutocompletePredictions(for tableDataSource: GMSAutocompleteTableDataSource) {
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        tableView.reloadData()
    }
    
    func tableDataSource(_ tableDataSource: GMSAutocompleteTableDataSource, didAutocompleteWith place: GMSPlace) {
        let vc = UIStoryboard.init(name: HomeConstants.main.rawValue, bundle:Bundle.main).instantiateViewController(withIdentifier: VcIdentifier.weatherDetailVC.rawValue) as? WeatherDetailViewController
        let location = CLLocation(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
        location.fetchCityAndCountry { city, country, error in
            let formatedCityName = self.replaceSpace(text: city ?? "")
            vc?.city = self.replaceSpace(text: formatedCityName)
            guard let viewController = vc else {
                return
            }
            self.navigationController?.pushViewController(viewController, animated: true)
            self.tableView.isHidden = true
            self.searchBar.text = ""
        }
        
    }
    
    func tableDataSource(_ tableDataSource: GMSAutocompleteTableDataSource, didFailAutocompleteWithError error: Error) {
        print("\(HomeConstants.errorString.rawValue) \(error.localizedDescription)")
    }
    
    func tableDataSource(_ tableDataSource: GMSAutocompleteTableDataSource, didSelect prediction: GMSAutocompletePrediction) -> Bool {
        return true
    }
}


//MARK: Api call
extension HomeViewController{
    
    func fillData() {
        let dispatchGroup = DispatchGroup()
        self.viewModel.cityList = []
        self.viewModel.locationList = []
        
        let locManager = CLLocationManager()
        locManager.requestWhenInUseAuthorization()
        
        var currentLocation: CLLocation!
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() ==  .authorizedAlways
        {
            currentLocation = CLLocationManager().location
            DispatchQueue.main.async {
                currentLocation.fetchCityAndCountry { city, country, error in
                    let cityUpdated = self.replaceSpace(text: city ?? "")
                    self.viewModel.cityList.append(cityUpdated)
                    dispatchGroup.enter()
                    self.viewModel.fetchData(city: cityUpdated, completionHandler:{ error in
                        if let error = error {
                            DispatchQueue.main.async {
                                let alert = UIAlertController(title: HomeConstants.errorString.rawValue, message: error.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                                alert.addAction(UIAlertAction(title: HomeConstants.ok.rawValue, style: UIAlertAction.Style.default, handler: nil))
                                self.present(alert, animated: true, completion: nil)
                            }
                        }
                        dispatchGroup.leave()
                    })
                }
            }
        }
        
        dispatchGroup.enter()
        viewModel.fetchFavLocation { locations in
            for location in locations {
                self.viewModel.cityList.append(location.location)
                dispatchGroup.enter()
                self.viewModel.fetchData(city: location.location, completionHandler:{ error in
                    if let error = error {
                        DispatchQueue.main.async {
                            let alert = UIAlertController(title: HomeConstants.errorString.rawValue, message: error.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                            alert.addAction(UIAlertAction(title: HomeConstants.ok.rawValue, style: UIAlertAction.Style.default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        }
                    }
                    dispatchGroup.leave()
                })
            }
            dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .main,execute: { [weak self] in
            self?.locationCollectionView.reloadData()
            self?.activityIndicator.stopAnimating()
        })
        
    }
}

enum HomeAccessibilityConstants: String {
    case signoutButtonAccessibilityLabel = "Sign out"
    case searchBarAccessibilityLabel = "Search Bar to enter city"
}

enum HomeConstants: String {
    case errorString = "Error"
    case ok = "OK"
    case main = "Main"
    case search = "Search"
}
