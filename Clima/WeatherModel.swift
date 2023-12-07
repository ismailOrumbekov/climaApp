//
//  WeatherModel.swift
//  Clima
//
//  Created by Ismail Orumbekov on 09.06.2023.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation
struct WeatherModel{
    let id : Int
    let cityName: String
    let temp : Double
    let minimum_temp : Double
    let maximum_temp : Double
    let feels_like_temp : Double
    let wind_speed : Double
    
    var temperatureString : String{
        return String(format: "%.1f", temp)
    }
    
    var conditionName : String{
        switch id {
                case 200...232:
                    return "cloud.bolt"
                case 300...321:
                    return "cloud.drizzle"
                case 500...531:
                    return "cloud.rain"
                case 600...622:
                    return "cloud.snow"
                case 701...781:
                    return "cloud.fog"
                case 800:
                    return "sun.max"
                case 801...805:
                    return "cloud.sun"
                default:
                    return "cloud"
                }
    }
}
