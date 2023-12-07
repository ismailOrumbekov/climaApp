//
//  WeatherData.swift
//  Clima
//
//  Created by Ismail Orumbekov on 08.06.2023.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation
struct WeatherData : Decodable{
    let name : String
    let weather : [Weather]
    let main : Main
    let wind : Wind
}

struct Weather : Decodable{
    let id : Int
}

struct Main : Decodable{
    let temp : Double
    let feels_like: Double
    let temp_min : Double
    let temp_max : Double
}

struct Wind : Decodable{
    let speed : Double
}
