//
//  WeatherManager.swift
//  Clima
//
//  Created by Ismail Orumbekov on 08.06.2023.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate{
    func didUpdateWeather(weather: WeatherModel)
}



struct WeatherManager{
    var delegate: WeatherManagerDelegate?
    var weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=27e386f958dfb5e41092993f753ae720&units=metric&"
    
    
    //Shows weather by name of the city
    func showWeather(city : String){
        //Creates a url, that will be used for API
         let urlString = "\(weatherURL)q=\(city)"
        performRequest(urlString: urlString)
    }
    
    //Shows weather by coordinates of the city
    
    func showWeather(latitude : CLLocationDegrees, longitude: CLLocationDegrees){
        //Creates a url, that will be used for API
        let urlString = "\(weatherURL)lat=\(latitude)&lon=\(longitude)"
        performRequest(urlString: urlString)
    }
    
    
    //MARK: - Request
    func performRequest(urlString : String){
        //Creating URL
        if let url = URL(string: "\(urlString)"){
            //Creating session for URL
            let urlSession = URLSession(configuration: .default)
            //Creating functional thal will works after getting data
            let task = urlSession.dataTask(with: url, completionHandler: handle(data:urlResponse:error:))
            //Starts our task
            task.resume()
        }
    }
    
    //MARK: - Closure (let task)
    //Functional that runs after getting data and task.resume() method
    func handle(data : Data?, urlResponse : URLResponse?, error : Error?){
        if error != nil{
            return
        }
        if let safeData = data{
            if let weather = parseJSON(data: safeData){
                delegate?.didUpdateWeather(weather: weather)
            }
        }
    }
    
    
    //MARK: - Parsing
    //Processing of received data
    func parseJSON(data : Data) -> WeatherModel?{
        let decoder = JSONDecoder()
        do{
            //Sending data in JSON format to decode it and save as WeatherData struct
            let decoderData = try decoder.decode(WeatherData.self, from: data)
            
            
            let name = decoderData.name
            let temp = decoderData.main.temp
            let id = decoderData.weather[0].id
            let feelsLike = decoderData.main.feels_like
            let min_temp = decoderData.main.temp_min
            let max_temp = decoderData.main.temp_max
            let wind_speed = decoderData.wind.speed
            
            return WeatherModel(id: id, cityName: name, temp: temp, minimum_temp: min_temp, maximum_temp: max_temp, feels_like_temp: feelsLike, wind_speed: wind_speed)
        }catch{
            return nil
        }

    }
}
