//
//  APIWeather.swift
//  MyWeather
//
//  Created by Rachid on 27/10/2016.
//  Copyright © 2016 Rachid. All rights reserved.
//

import Foundation
import ForecastIO

class APIWeather{
    
    
    // API SECRET KEY FORECASTIO
    // CREER UN COMPTE SUR FORECASTIO AFIN DE DE RECUPERER LA KEY SECRET
    // AFIN DE POUVOIR FAIRE DES REQUEST POUR LES DONNEES METEO
    private var client = DarkSkyClient(apiKey: "")
    var weatherHistory : [Weather] = []
    
    private struct imageNameSource {
        static let rain = "rainning"
        static let cloudy = "cloudy"
        static let partly_cloudy = "partly_cloudy"
        static let snowing = "snowing"
        static let sunny = "sunny"
        static let clear_night = "clear_night"
        static let fog = "fog"
        static let wind = "wind"
        static let cloudy_night = "cloudy_night"
    }
    
    func getWeatherInfo(weatherData: Weather, completionHandler: @escaping (String) -> ()){
        client.language = .french
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        client.getForecast(latitude: (weatherData.locationCity?.latitude)!, longitude: (weatherData.locationCity?.longitude)! ) { (result) in
            switch result {
            case .success(let currentForecast, _):
                DispatchQueue.main.async {
                    if (currentForecast.currently?.summary) != nil {
                        self.parseWeatherInfo(data: currentForecast.currently!, newWeather: weatherData)
                        completionHandler("SUCCESS")
                    }
                }
            case .failure(_):
                break
            }
        }
    }
  
    
    private func parseWeatherInfo(data: DataPoint, newWeather: Weather) {
        
        newWeather.weatherImgName = getImageStringFromTypeWeather(weatherType: data.icon!)
        newWeather.infoText = data.summary
        newWeather.humidity = round(data.humidity ?? 0.0)
        newWeather.windSpeed = round(data.windSpeed ?? 0.0)
        newWeather.visibility = round(data.visibility ?? 0.0)
        
        
        newWeather.temperature =  round(data.temperature!)
        
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: data.time)
        let minut = calendar.component(.minute, from: data.time)

        newWeather.time = "\(hour):\(minut)"
        
        weatherHistory.append(newWeather)
    }
    
    private func getImageStringFromTypeWeather(weatherType: Icon) -> String {
        switch weatherType {
        case .clearNight : return imageNameSource.clear_night
        case .cloudy: return imageNameSource.cloudy
        case .snow: return imageNameSource.snowing
        case .sleet: return imageNameSource.snowing
        case .rain: return imageNameSource.rain
        case .wind: return imageNameSource.wind
        case .fog: return imageNameSource.fog
        case .partlyCloudyDay: return imageNameSource.partly_cloudy
        case .partlyCloudyNight: return imageNameSource.cloudy_night
        default: return imageNameSource.sunny
        }
    }
    
}
