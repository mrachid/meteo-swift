 //
//  ViewController.swift
//  meteo
//
//  Created by Rachid on 02/11/2016.
//  Copyright © 2016 Rachid. All rights reserved.
//

import UIKit
import ForecastIO
import CoreLocation

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!

    @IBAction func unWindSegue(segue: UIStoryboardSegue){}

    private let apiWeather = APIWeather()
    var searchCityText : String?{
        didSet{
            if searchCityText != nil{
                getCityLocation(city: searchCityText!)
            }
        }
    }
    private var weather : Weather?{
        didSet{
            apiWeather.getWeatherInfo(weatherData: weather!) { (info) in
                self.tableView.reloadData()
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
        }
    }
    
    private struct StoryBoard {
        static let searchWeather = "searchWeatherSegue"
    }
    
    private let weatherDefault = ["Paris", "Pékin", "Los Angeles", "Rome", "Moscou", "Berlin"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for value in weatherDefault{
            getCityLocation(city: value)
        }
        
    }
    
    private func getCityLocation(city: String) {
        
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(city, completionHandler: { placemarks, error in
            if error != nil {
                print("Une erreur est survenue : \r\n \(error)")
                return
            }
            if let placemarks = placemarks {
                let placemark = placemarks[0]
                let name = placemark.locality ?? city
                self.weather = Weather(location: (placemark.location?.coordinate)!, name: name)
            }
        })
        
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return apiWeather.weatherHistory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "meteoCell", for: indexPath) as? meteoTableViewCell
        
        cell?.cityLabel.text = apiWeather.weatherHistory[indexPath.row].nameCity
        cell?.temperatureLabel.text = String(Int(apiWeather.weatherHistory[indexPath.row].temperature!)) + "°F"
        cell?.meteoImageView.image = UIImage(named: apiWeather.weatherHistory[indexPath.row].weatherImgName!)
        cell?.timeLabel.text = apiWeather.weatherHistory[indexPath.row].time
        cell?.infoLabel.text = apiWeather.weatherHistory[indexPath.row].infoText
        
        return cell!
    }
    
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete)
        {
            apiWeather.weatherHistory.remove(at: indexPath.row)
            tableView.reloadData()
        }
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
}

