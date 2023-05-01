//
//  HomeViewConstants.swift
//  WeatherApp
//
//  Created by Panchami Shenoy on 02/02/22.
//

import UIKit

enum ImageAssetName: String {
    case bangalore = "bangalore"
    case mangalore = "mangalore"
    case delhi = "delhiIndia"
    case bombay = "bombay"
    case homeBackground = "background"
    case cloudyDay = "cloudyDay"
    case cloudyNight = "cloudyNight"
    case clearDay = "clearDay"
    case clearNight = "clearNight"
    case rainyDay = "rainyNight"
    // case rainyNight = "rainyNight"
    case hazeDay = "hazeDay"
    case hazeNight = "hazeNight"
}

enum ImageSystemName: String {
    case drizzle = "cloud.drizzle"
    case rain = "cloud.rain"
    case cloud = "cloud"
    case snow = "cloud.snow"
    case haze = "sun.haze"
    case clear = "cloud.sun"
    case smoke = "smoke"
    case backButtonImage = "chevron.backward.circle"
    case bookmark = "bookmark"
    case bookmarkFill = "bookmark.fill"
    
}

enum WeatherCondition: String {
    case smoke = "Smoke"
    case haze = "Haze"
    case clouds = "Clouds"
    case clear = "Clear"
    case mist = "Mist"
    case rain = "Rain"
    
}
enum CellIdentifier: String {
    case locationCell = "locationCell"
    case WeatherDetailTableViewCell = "WeatherDetailTableViewCell"
}
enum VcIdentifier: String {
    case weatherDetailVC = "weatherDetails"
    case signinVC = "signinvc"
    case signupVC = "signupvc"
    case homeVC = "homeVC"
}

enum ThicknessForBorder: CGFloat {
    case thicknessOne = 4.0
    case thicknessTwo = 2.0
    case thicknessThree = 1.0
}

enum SearchBarBorderConstants: CGFloat {
    case borderWidth = 0.5
    case borderRadius = 30
}

enum CollectionViewSizeConstants: CGFloat {
    case height = 250.0
    case allignmentSpacing = 22.0
    case cornerRadius = 20
    case lineSpacing = 10
    case interItemSpacing = 21
}

enum TimeStringConstants: String {
    case am = "am"
    case pm = "pm"
}

enum TimeNumberConstants: Int {
    case six = 6
    case twelve = 12
}

enum WeatherDetailKey: String {
    case feelsLike = "feelsLike"
    case pressure = "pressure"
    case humidity = "humidity"
    case visibilty = "visibilty"
    case windSpeed = "windSpeed"
    case clouds = "clouds"
    case uvi = "uvi"
    case dewPoint = "dewPoint"
}
enum UnicodeConstants: String {
    case degree = "\u{00B0}C"
}

enum Url: String {
    case baseUrl = "https://api.openweathermap.org/data/2.5"
    case apiKey = "&appid=ad0759d957e09204e3bebf5f5a1ea289"
}

enum AccessibilityConstants: String {
    case doubleTapToActive = "double tap to Activate"
}

struct UiConstants {
    let avenirBookBody = UIFont(name:"Avenir Book", size: 20.0)
    let avenirBookTitle = UIFont(name: "Avenir Book",size: 35.0)
}
