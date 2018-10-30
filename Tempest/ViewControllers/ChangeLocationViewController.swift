//
//  ChangeLocationViewController.swift
//  Tempest
//
//  Created by Kyle Houts on 10/26/18.
//  Copyright © 2018 Kyle Houts. All rights reserved.
//

import UIKit

class ChangeLocationViewController: UIViewController, UISearchBarDelegate {
    
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    // Instance of the API Manager class so we can make API calls on this screen
    let apiManager = APIManager()
    
    var geocodingData: GeocodingData?
    var weatherData: WeatherData?
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        
    }
    
    
    // If something goes wrong with one of the API calls, call this to make sure we aren't holding on to any geocoding or weather data
    func handleError() {
        geocodingData = nil
        weatherData = nil
    }
    
    
    func retrieveGeocodingData(searchAddress: String) {
        apiManager.geocode(address: searchAddress)
        { (geocodingData, error) in
            if let recievedError = error {
                print(recievedError.localizedDescription)
                self.handleError()
                return
                
            }
            
            if let receivedData = geocodingData {
                self.geocodingData = receivedData
                
                // Use that data to make a Dark Sky call
                self.retrieveWeatherData(latitude: receivedData.latitude, longitude: receivedData.longitude)
            } else {
                self.handleError()
                return
            }
        }
    }
    
    
    func retrieveWeatherData(latitude: Double, longitude: Double) {
        
        apiManager.getWeather(latitude: latitude, longitude: longitude) { (weatherData, error) in
            if let receivedError = error {
                print(receivedError.localizedDescription)
                self.handleError()
                return
            }
            if let receivedData = weatherData {
                self.weatherData = receivedData
                self.performSegue(withIdentifier: "unwindToMainScreen", sender: self)
            } else {
                self.handleError()
                return
            }
        }
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // Try to replace any spaces in the search bar text with + signs. If you can't stop running the function
        guard let searchAddress = searchBar.text?.replacingOccurrences(of: " ", with: "+") else {
            return
        }
        retrieveGeocodingData(searchAddress: searchAddress)
    }
    
    
    
    
    
    
    
    //    var searchLocation: String = ""
    //
    //
    
    //
    //        searchBar.delegate = self
    //    }
    //
    //
    //
    //    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    //        let searchLocation = searchText
    //    }
    //
    //
    //    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    //        performSegue(withIdentifier: "unwindToMainScreen", sender: self)
    //        print(searchLocation)
    //    }
    //
    //
    //    var mainViewController: ViewController?
    //
    //
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? ViewController, let retrievedGeocodingData = geocodingData, let retrievedWeatherData = weatherData {
            destinationVC.displayGeocodingData = retrievedGeocodingData
            destinationVC.displayWeatherData = retrievedWeatherData
            
            
        }
        
    }
}






