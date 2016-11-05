//
//  weather.swift
//  MyWeather
//
//  Created by Rachid on 27/10/2016.
//  Copyright © 2016 Rachid. All rights reserved.
//

import Foundation
import CoreLocation

class Weather {
    
    var locationCity : CLLocationCoordinate2D?
    var nameCity : String?
    var weatherImgName : String?
    var temperature : Float?
    var windSpeed : Float?
    var infoText : String?
    var time : String?
    var humidity: Float?
    var visibility: Float?
    
    init(location : CLLocationCoordinate2D, name: String) {
        self.locationCity = location
        self.nameCity = name
    }

}
