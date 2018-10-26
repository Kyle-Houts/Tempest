//
//  ViewController.swift
//  Tempest
//
//  Created by Kyle Houts on 10/24/18.
//  Copyright © 2018 Kyle Houts. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON



class ViewController: UIViewController {
    
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var currentWeatherIcon: UILabel!
    
    @IBOutlet weak var highTemperatureLabel: UILabel!
    
    @IBOutlet weak var lowTemperatureLabel: UILabel!
    
    
    @IBOutlet weak var currentTemperatureLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let apiKeys = APIKeys()
        
        
        
        // GOOGLE REQUEST
        
        let googleBaseURL = "https://maps.googleapis.com/maps/api/geocode/json?address="
        
        let googleRequestURL = googleBaseURL + "Seattle,+Washington" + "&key=" + apiKeys.googleKey
        
        let googleRequest = Alamofire.request(googleRequestURL)
        
        googleRequest.responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print(json)
                
                let darkSkyURL = "https://api.darksky.net/forecast/"
                
                let darkSkyKey = apiKeys.darkSkyKey
                
                var latitude: Double! = 36.9959
                
                var longitude: Double! = -85.9119
                
                if let latJSON = json["results"]["address_components"]["geometry"]["location"]["lat"].double {
                    latitude = latJSON
                }

                if let lngJSON = json["results"]["address_components"]["geometry"]["location"]["lng"].double {
                    longitude = lngJSON
                }
                
                // DARKSKY REQUEST
                
                let url = "\(darkSkyURL)\(darkSkyKey)/\(latitude),\(longitude)"

                
                let request = Alamofire.request(url)
                
                request.responseJSON { response in
                    switch response.result {
                    case .success(let value):
                        let json = JSON(value)
                        //                print(json)
                        
                        
                        // changes currentWeatherIcon
                        let currentWeatherJSON = json["currently"]["icon"].string
                        var currentWeather: String
                        
                        switch currentWeatherJSON {
                        case "clear-day":
                            currentWeather = "☀️"
                        case "clear-night":
                            currentWeather = "🌕"
                        case "rain":
                            currentWeather = "🌧"
                        case "snow":
                            currentWeather = "🌨"
                        case "sleet":
                            currentWeather = "❄️"
                        case "wind":
                            currentWeather = "🌬"
                        case "fog":
                            currentWeather = "🌫"
                        case "cloudy":
                            currentWeather = "☁️"
                        case "partly-cloudy-day":
                            currentWeather = "🌤"
                        case "partly-cloudy-night":
                            currentWeather = "🌥"
                        case "hail":
                            currentWeather = "☃️"
                        case "thunderstorm":
                            currentWeather = "⛈"
                        case "tornado":
                            currentWeather = "🌪"
                        default:
                            currentWeather = "🌈"
                        }
                        
                        
                        self.currentWeatherIcon.text = currentWeather
                        
                        // changes currentTemperature
                        if let currentTemperature = json["currently"]["temperature"].double {
                            self.currentTemperatureLabel.text =
                            "\(currentTemperature)℉"
                        }
                        
                        // Sets high label
                        if let highTemperature = json["daily"]["data"][0]["temperatureHigh"].double {
                            self.highTemperatureLabel.text = "\(highTemperature)℉"
                        }
                        
                        // Sets low label
                        if let lowTemperature = json["daily"]["data"][0]["temperatureLow"].double {
                            self.lowTemperatureLabel.text = "\(lowTemperature)℉"
                        }
                        
                        
                    // If data cannot be pulled from DarkSky
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
                
            // If data cannot be pulled from Google
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
    }
    
// Unwind segue from chooseLocation screen
    @IBAction func unwindToMainScreen(segue: UIStoryboardSegue) { }
    
}
