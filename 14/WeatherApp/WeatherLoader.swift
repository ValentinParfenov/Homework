
import Foundation
import SwiftyJSON
import RealmSwift

protocol LoadWeatherDelegate {
    func loaded (currentTemperature: String, feelsLikeTemperature: String, minTemperature: String, maxTemperature: String, nameTownLabel: String)
}

class WeatherDataLoader: Object {
    @objc dynamic var currentTemperature = "\(Double.self)"
    @objc dynamic var feelsLikeTemperature = "\(Double.self)"
    @objc dynamic var nameTown = "\(Double.self)"
    @objc dynamic var minTemperature = "\(Double.self)"
    @objc dynamic var maxTemperature = "\(Double.self)"
}

class WeatherLoader {
    let realm = try! Realm()
    var dataW = [WeatherDataLoader]()
    var weatherData: Results<WeatherDataLoader>!
    var delegate: LoadWeatherDelegate?
    
    func loadWeather () {
        let key = "bc8fc8363c5c900dd10131ef7dfefcbb"
        let town = "Lissabon"
        let urlCurrentWeather = "https://api.openweathermap.org/data/2.5/weather?q=\(town)&units=metric&appid=\(key)"
        let url = URL (string: urlCurrentWeather)
            
        var currentTemperature: Double?
        var feelsLikeTemperature: Double?
        var minTemperature: Double?
        var maxTemperature: Double?

        let weatherData = realm.objects(WeatherDataLoader.self).last!
        
        DispatchQueue.main.async {
        self.delegate?.loaded(
            currentTemperature: "\(weatherData.currentTemperature)",
            feelsLikeTemperature: "\(weatherData.feelsLikeTemperature)",
            minTemperature:"\(weatherData.minTemperature)",
            maxTemperature:"\(weatherData.maxTemperature)",
            nameTownLabel: weatherData.nameTown
        )
        }
        print(weatherData)
        
        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String: AnyObject]
                if let mainNS = json["main"] {
                    currentTemperature = mainNS["temp"] as? Double
                    feelsLikeTemperature = mainNS["feels_like"] as? Double
                    minTemperature = mainNS["temp_min"] as? Double
                    maxTemperature = mainNS["temp_max"] as? Double
                    print(json)
                }
                
                DispatchQueue.main.async {
                    self.delegate?.loaded(
                        currentTemperature: "\(currentTemperature!)",
                        feelsLikeTemperature: "\(feelsLikeTemperature!)",
                        minTemperature:"\(minTemperature!)",
                        maxTemperature:"\(maxTemperature!)",
                        nameTownLabel: town
                    )
                    try! self.realm.write {
                        self.realm.add(weatherData)
                    }
                    print(weatherData)
                }
            }
            
            catch let jsonError {
                print(jsonError)
            }
        }
        task.resume()
    }
}
