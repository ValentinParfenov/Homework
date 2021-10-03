
import Foundation
import SwiftyJSON
import RealmSwift

protocol LoadWeatherDelegate {
    func loaded (currentTemperature: String, feelsLikeTemperature: String, minTemperature: String, maxTemperature: String, nameTownLabel: String)
}

class WeatherDataLoader: Object {
    @objc dynamic var currentTemperature = ""
    @objc dynamic var feelsLikeTemperature = ""
    @objc dynamic var nameTown = ""
    @objc dynamic var minTemperature = ""
    @objc dynamic var maxTemperature = ""
}

class WeatherLoader {
    let realm = try! Realm()
    var dataW = [WeatherDataLoader]()
    var weatherData: Results<WeatherDataLoader>!
    var delegate: LoadWeatherDelegate?
    
    func loadFirst () {
        let weatherLoadFirst = realm.objects(WeatherDataLoader.self)
        let newWeather = WeatherDataLoader()
        
        if newWeather.currentTemperature.isEmpty, newWeather.feelsLikeTemperature.isEmpty, newWeather.nameTown.isEmpty, newWeather.minTemperature.isEmpty, newWeather.maxTemperature.isEmpty {
            delegate?.loaded(currentTemperature: "-/-", feelsLikeTemperature: "-/-", minTemperature: "-/-", maxTemperature: "-/-", nameTownLabel: "-/-")
        }
        try! self.realm.write {
            self.realm.add(weatherLoadFirst)
        }
    }
    
    func loadWeather () {
        self.loadWeatherFromCache()
        self.loadWeatherFromAPI()
    }
    
    func loadWeatherFromCache () {
        let weatherDataCache = realm.objects(WeatherDataLoader.self).last
        
        if weatherDataCache != nil {
            DispatchQueue.main.async {
                self.delegate?.loaded(
                    currentTemperature: "\(weatherDataCache!.currentTemperature)",
                    feelsLikeTemperature: "\(weatherDataCache!.feelsLikeTemperature)",
                    minTemperature:"\(weatherDataCache!.minTemperature)",
                    maxTemperature:"\(weatherDataCache!.maxTemperature)",
                    nameTownLabel: weatherDataCache!.nameTown
                )
            }
        }
    }
    
    func loadWeatherFromAPI () {
        let key = "bc8fc8363c5c900dd10131ef7dfefcbb"
        let town = "Sydney"
        let urlCurrentWeather = "https://api.openweathermap.org/data/2.5/weather?q=\(town)&units=metric&appid=\(key)"
        let url = URL (string: urlCurrentWeather)
        
        let weatherAPIDataLoader = WeatherDataLoader()

        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String: AnyObject]

                if let mainNS = json["main"] {
                    weatherAPIDataLoader.currentTemperature = String(describing: mainNS["temp"] as! Double)
                    weatherAPIDataLoader.feelsLikeTemperature = String(describing: mainNS["feels_like"] as! Double)
                    weatherAPIDataLoader.minTemperature = String(describing: mainNS["temp_min"] as! Double)
                    weatherAPIDataLoader.maxTemperature = String(describing: mainNS["temp_max"] as! Double)
                    weatherAPIDataLoader.nameTown = town
                }

                DispatchQueue.main.async {
                    self.delegate?.loaded(
                        currentTemperature: weatherAPIDataLoader.currentTemperature,
                        feelsLikeTemperature: weatherAPIDataLoader.feelsLikeTemperature,
                        minTemperature: weatherAPIDataLoader.minTemperature,
                        maxTemperature: weatherAPIDataLoader.maxTemperature,
                        nameTownLabel: weatherAPIDataLoader.nameTown
                    )

                    try! self.realm.write {
                        self.realm.add(weatherAPIDataLoader)
                    }
                }
            }
            
            catch let jsonError {
                print(jsonError)
            }
        }
        task.resume()
    }
}
