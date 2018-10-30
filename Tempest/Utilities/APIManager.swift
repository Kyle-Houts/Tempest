//
//  APIManager.swift
//  Tempest
//
//  Created by Kyle Houts on 10/29/18.
//  Copyright © 2018 Kyle Houts. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

class APIManager {
    
    // Base URL for the DarkSky API
    private let darkSkyURL = "https://api.darksky.net/forecast/"
    
    
    // Base URL for the Google Geocoding API
    private let googleBaseURL = "https://maps.googleapis.com/maps/api/geocode/json?address="
    
    private let apiKeys = APIKeys()
    
    
    
    // Enum containing different errors we could get from trying to connect to an API
    enum APIErrors: Error {
        case noData
        case noResponse
        case invalidData
    }
    
    
    
    // Going to call the DarkSky API and get a latitude and longitude
    func getWeather(latitude: Double, longitude: Double, onCompletion: @escaping (WeatherData?, Error?) -> Void) {
        
        
        
        let url = "\(darkSkyURL)\(apiKeys.darkSkyKey)/\(latitude),\(longitude)"
        
        let darkSkyRequest = Alamofire.request(url)
        
        darkSkyRequest.responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print(json)
                if let weatherData = WeatherData(json: json) {
                    onCompletion(weatherData, nil)
                } else {
                    onCompletion(nil, APIErrors.invalidData)
                }
            case .failure(let error):
                print(error)
                onCompletion(nil, error)
            }
        }
    }
    
    
    // Attempt to geocode the address that's passed in. Afterward, call the onCompletion closure by passing in geocoding data or an error
    func geocode(address: String, onCompletion: @escaping (GeocodingData?, Error?) -> Void) {
        
        
        // The URL for our Google Geocoding API call
        let googleRequestURL = self.googleBaseURL + address + "&key=" + self.apiKeys.googleKey
        
        let googleRequest = Alamofire.request(googleRequestURL)
        
        googleRequest.responseJSON { response in
            switch response.result {
                
            case .success(let value):
                let json = JSON(value)
                
                // If the JSON can be converted into Geocoding data, call the completion closure by passing in the geocoding data and nil for the error
                if let geocodingData = GeocodingData(json: json) {
                    onCompletion(geocodingData, nil)
                } else {
                    onCompletion(nil, APIErrors.invalidData)
                }
                
            case .failure(let error):
                onCompletion(nil, error)
                
            }
            
        }
        
    }
    
}




