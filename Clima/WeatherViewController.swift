//
//  ViewController.swift
//  WeatherApp
//
//  Created by Angela Yu on 23/08/2015.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON

class WeatherViewController: UIViewController, CLLocationManagerDelegate, ChangeCityDelegate {
    
    //Constants
    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather"
    let APP_ID = "b65f8f720304eaac3a7010748c2ad2c8" //"e72ca729af228beabd5d20e3b7749713"
    /***Get your own App ID at https://openweathermap.org/appid ****/
    

    //TODO: Declare instance variables here
    let locationManager = CLLocationManager()
    var weatherDataModel = WeatherDataModel()
    
    //Pre-linked IBOutlets
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //TODO:Set up the location manager here.
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestAlwaysAuthorization()
        // s'exécute en background et appel notre callback didUpdateLocation
        locationManager.startUpdatingLocation()
        
    }
    
    
    //MARK: - Networking
    /***************************************************************/
    
    //Write the getWeatherData method here:
    func getWeatherData(url: String, parameters: [String: String]) {
        print("send request")
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON {
            response in
            if response.result.isSuccess {
                print("Hey dude, we got the weather data")
                // Automatic unwrap est safe car on a déjà fait un check isSUccess
                let weaatherJSON: JSON = JSON(response.result.value!)
                print(weaatherJSON)
                self.weatherDataModel.updateWeatherData(with: weaatherJSON)
                self.updateUIWithWeatherData()
            }
            else {
                print("Error in Alamofire: \(response.result.error!)")
                self.cityLabel.text = "Connection issue, try later"
            }
        }
    }

    
    
    //MARK: - JSON Parsing
    /***************************************************************/
   
    
    //Write the updateWeatherData method here:
    func updateWeatherData(with json: JSON) {
//        weatherDataModel.temperature = Int(json["main"]["temp"].double! - 273.15)
//        weatherDataModel.city = String(json["name"].string!)
//        // il peut y avoir plusieurs condition pour une même ville
//        // on récupère le premier donc le [0]
//        weatherDataModel.condition = Int(json["weather"][0]["id"].int!)
//
//        weatherDataModel.weatherIconName = weatherDataModel.updateWeatherIcon(condition: weatherDataModel.condition)
        weatherDataModel.updateWeatherData(with: json)
    }

    
    
    //MARK: - UI Updates
    /***************************************************************/
    
    
    //Write the updateUIWithWeatherData method here:
    func updateUIWithWeatherData() {
        cityLabel.text = weatherDataModel.city
        temperatureLabel.text = "\(weatherDataModel.temperature)°"
        weatherIcon.image = UIImage(named: weatherDataModel.weatherIconName)
    }
    
    
    
    //MARK: - Location Manager Delegate Methods
    /***************************************************************/
    
    
    //Write the didUpdateLocations method here:
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // On récupère la dernière car c'est la pus précise
        let location = locations[locations.count-1]
        if location.horizontalAccuracy > 0 {
            locationManager.stopUpdatingLocation()
            
            print("long \(location.coordinate.longitude) lat \(location.coordinate.latitude)")
            
            let latitude = String(location.coordinate.latitude)
            let longitude = String(location.coordinate.longitude)
            let parameters: [String : String] = ["lat" : latitude, "lon" : longitude, "appid": APP_ID]
            
            getWeatherData(url: WEATHER_URL, parameters: parameters)
            print("update UI with")
            print(weatherDataModel)
            updateUIWithWeatherData()
        }
    }
    
    
    //Write the didFailWithError method here:
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        cityLabel.text = "Location unavailable 😔"
    }
    
    
    //MARK: - Change City Delegate methods
    /***************************************************************/
    
    
    //Write the userEnteredANewCityName Delegate method here:
    func userEnterANewCityName(city: String) {
//        print("get new city name as (city)")
        self.cityLabel.text = city
        
        let params: [String:String] = ["q": city, "appId": APP_ID]
        
        getWeatherData(url: WEATHER_URL, parameters: params)
    }
    

    
    //Write the PrepareForSegue Method here
    // méthode appelé quand le Segue est activé
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // c'est de cette façon on détect quel Segue est effectivement appelé
        // il peut y avoir plusieurs Segues pour le même VC
        if segue.identifier == "changeCityName" {
            let destinationVC = segue.destination as! ChangeCityViewController
            // et maintenant on s'enregistre
            print("set myself as delegate")
            destinationVC.delegate = self
        }
    }
    
    
}


