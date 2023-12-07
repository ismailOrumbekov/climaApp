

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {

    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var feelsLikeLabel: UILabel!
    @IBOutlet weak var minTempLabel: UILabel!
    @IBOutlet weak var maxTempLabel: UILabel!
    @IBOutlet weak var windSpeed: UILabel!
    
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        weatherManager.delegate = self
        searchTextField.delegate = self
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        setStackView()
    }
    
    @IBAction func locationButtonPressed(_ sender: UIButton) {
        locationManager.requestLocation()
    }
    
    
    func setStackView(){
        stackView.layer.cornerRadius = 10
        stackView.layer.opacity = 0.5
        
    }
    
}


//MARK: - UITextFieldDelegate

extension WeatherViewController: UITextFieldDelegate{
    
    @IBAction func searchPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
 
    //if enter pressed without city
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text! == ""{
            textField.placeholder = "Write something"
            return false
        }else{
            return true
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        weatherManager.showWeather(city: textField.text ?? "almaty")
        textField.text = ""
    }
}


//MARK: - After updatind Weather
extension WeatherViewController : WeatherManagerDelegate{
    func didUpdateWeather(weather: WeatherModel) {
        DispatchQueue.main.async {
            self.setWeather(temp: weather.temperatureString,
                conditionName: weather.conditionName,
                cityName: weather.cityName,
                minimum_temp: weather.minimum_temp,
                maximum_temp: weather.maximum_temp,
                wind_speed: weather.wind_speed,
                feels_like_temp: weather.feels_like_temp)
        }
    }
    
    
    func setWeather(temp: String, conditionName: String, cityName: String, minimum_temp: Double, maximum_temp : Double, wind_speed: Double, feels_like_temp: Double){
        self.temperatureLabel.text = temp
        self.conditionImageView.image = UIImage(systemName: conditionName)
        self.cityLabel.text = cityName
        self.feelsLikeLabel.text = String(format: "%.1f", feels_like_temp)
        self.minTempLabel.text = "Min temp: \(String(format: "%.1f", minimum_temp)) °C"
        self.maxTempLabel.text = "Max temp: \(String(format: "%.1f", maximum_temp)) °C"
        self.windSpeed.text = "Wind speed: \(wind_speed)m/s"
        
    }
}



//MARK: - CLLocationManagerDelegate
//Used for checking setting weather of current location

extension WeatherViewController : CLLocationManagerDelegate{
    //Works after location was correctly setted
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        manager.stopUpdatingHeading()
        if let location = locations.last{
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.showWeather(latitude: lat, longitude: lon)
        }
    }
    
    //Works only if there were problems with request location
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("smthwrong")
    }
}
