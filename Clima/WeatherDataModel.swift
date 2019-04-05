//
//  WeatherDataModel.swift
//  WeatherApp
//
//  Created by Angela Yu on 24/08/2015.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//

import UIKit
import SwiftyJSON

class WeatherDataModel {

    //Declare your model variables here
    var temperature: Int = 0
    var condition: Int = 0
    var city: String = ""
    var weatherIconName: String = ""
    
    // Comme j'ai défini un init avec param il faut déclarer celui par défaut
    // explicitement.
    init() {
        
    }
    
    // Une méthode à partir de JSON
    // en fait dans le cours ce code est fait dans le controller et
    // il y a un test pour tester le bon retour pour temperature
    // il est en fait possible d'avoir un isSuccess sanbs pour autant avoir
    // des données temperrature n si par exemple appId est mauvais
    // ou encore je pense si les lon lat sont pourris
    
    func updateWeatherData(with json: JSON) {
        self.temperature = Int(json["main"]["temp"].double! - 273.15)
        self.city = String(json["name"].string!)
        // il peut y avoir plusieurs condition pour une même ville
        // on récupère le premier donc le [0]
        self.condition = Int(json["weather"][0]["id"].int!)
        self.weatherIconName = updateWeatherIcon(condition: condition)

    }
    
    //This method turns a condition code into the name of the weather condition image
    func updateWeatherIcon(condition: Int) -> String {
    
        switch (condition) {
        case 0...300 :
            return "tstorm1"
        
        case 301...500 :
            return "light_rain"
        
        case 501...600 :
            return "shower3"
        
        case 601...700 :
            return "snow4"
        
        case 701...771 :
            return "fog"
        
        case 772...799 :
            return "tstorm3"
        
        case 800 :
            return "sunny"
        
        case 801...804 :
            return "cloudy2"
        
        case 900...903, 905...1000  :
            return "tstorm3"
        
        case 903 :
            return "snow5"
        
        case 904 :
            return "sunny"
        
        default :
            return "dunno"
        }
    }
}