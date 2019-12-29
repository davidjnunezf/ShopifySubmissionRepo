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

class WeatherViewController: UIViewController, CLLocationManagerDelegate,ChangeCityDelegate{
    
    //Constants
    //website we get our weather info from
    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather"
    //change app Id to my own Id
    let APP_ID = "92eea109742a96c83616550b59232dc6"
    /***Get your own App ID at https://openweathermap.org/appid ****/
    

    //TODO: Declare instance variables here
    var locationManager:CLLocationManager = CLLocationManager()
    
    var weatherDataModel = WeatherDataModel()
    
    //Pre-linked IBOutlets
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //TODO:Set up the location manager here.
        locationManager.delegate = self//initiliaze the location deligate
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters //location accuracy
        locationManager.requestWhenInUseAuthorization() //give user permission requests remember to change plist file to accustom
        locationManager.startUpdatingLocation() //start catching location
    }
    
    
    
    //MARK: - Networking
    /***************************************************************/
    
    //Write the getWeatherData method here:
    //Javascript Object Notation
    func getWeatherData(url: String, parameters:[String:String]){
        
        Alamofire.request(url,method: .get, parameters: parameters).responseJSON {
            response in
            if response.result.isSuccess {
                print("Success")
                
                let weatherJSON:JSON = JSON(response.result.value!)
                
                self.updateWeatherData(weatherJSON)
             //   cityLabel.text = response.result.
            }
            else{
                print("error problem is \(response.result.error)")
                 self.cityLabel.text = "Connection Failed"
            }
        }
        
    }

    
    
    
    
    
    //MARK: - JSON Parsing
    /***************************************************************/
   
    
    //Write the updateWeatherData method here:
    
    func updateWeatherData(_ json:JSON){
        
        if let tempResult = json["main"]["temp"].double{
        
        weatherDataModel.temperature = Int(tempResult - 273.15)
        
        let CityName = json["name"].string
        
        weatherDataModel.city = CityName!
            
        
        
        let Weathercondition = json["weather"][0]["id"].int
        
        weatherDataModel.condition = Weathercondition!
        
        weatherDataModel.weatherIconName = weatherDataModel.updateWeatherIcon(condition: weatherDataModel.condition)
            
            updateUIWithWeatherData()
        }
        
        else{
            cityLabel.text = "Weather Unavailable"
        }
    }

    
    
    
    //MARK: - UI Updates
    /***************************************************************/
    
    
    //Write the updateUIWithWeatherData method here:
    func updateUIWithWeatherData(){
        cityLabel.text = weatherDataModel.city
        weatherIcon.image = UIImage(named: "\(weatherDataModel.weatherIconName)")
        temperatureLabel.text = String(weatherDataModel.temperature)
        
    }
    
    
    
    
    
    //MARK: - Location Manager Delegate Methods
    /***************************************************************/
    
    
    //Write the didUpdateLocations method here:
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
       //Last location in locations array is most accurate
        let location = locations[locations.count-1]
        if location.horizontalAccuracy > 0 { //when horizontal accuracy is greater then 0 we have a valid location
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil
            print("longitude = \(location.coordinate.longitude), latitude = \(location.coordinate.latitude)")
            
            let latitude = location.coordinate.latitude
            
            let longitude = location.coordinate.longitude
            //create a dicitonary so we can communicate with the API
            let params: [String:String] = ["lat" : "\(latitude)", "lon" : "\(longitude)", "appid" : APP_ID]
            getWeatherData(url: WEATHER_URL, parameters: params)
        }
        
    }
    
    
    //Write the didFailWithError method here:
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        cityLabel.text = "Location Unavailable"
    }
    

    
    //MARK: - Change City Delegate methods
    /***************************************************************/
    
    
    //Write the userEnteredANewCityName Delegate method here:
    func userEnteredANewCityName(city:String){
        let params: [String:String] = ["q" : city,"appid" : APP_ID]
        getWeatherData(url: WEATHER_URL, parameters: params)
    }

    
    //Write the PrepareForSegue Method here
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "changeCityName" {
            let destinationVC = segue.destination as! ChangeCityViewController
            destinationVC.delegate = self
        }
    }
    
    
    
}


