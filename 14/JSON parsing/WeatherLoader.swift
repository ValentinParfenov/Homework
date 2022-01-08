
import Foundation
import SwiftyJSON

protocol LoadWeatherDelegate {
    func loaded(
        currentTemperature: String,
        feelsLikeTemperature: String,
        minTemperature: String,
        maxTemperature: String,
        humidity: String,
        pressure: String,
        nameTownLabel: String
    )
    
    func loadedDetail(
        description: String
    )
}

class WeatherLoader {
    var delegate: LoadWeatherDelegate?
    let realmManager = RealmWeatherManager()
    let realmDetailManager = RealmDetailWeather()
    let realmTownManager = RealmTownManager()
    var town = ""
    
    func loadFirst () {
        let newWeather = WeatherDataLoader()
        let newDetailWeather = WeatherDetail()
        
        if newWeather.currentTemperature.isEmpty, newWeather.feelsLikeTemperature.isEmpty, newWeather.nameTown.isEmpty, newWeather.minTemperature.isEmpty, newWeather.maxTemperature.isEmpty {
            delegate?.loaded(
                currentTemperature: "-/-",
                feelsLikeTemperature: "-/-",
                minTemperature: "-/-",
                maxTemperature: "-/-",
                humidity: "-/-",
                pressure: "-/-",
                nameTownLabel: "-/-"
            )
        }
        realmManager.loadWeatherFirst()
        
        if newDetailWeather.descriptionWeather.isEmpty {
            delegate?.loadedDetail(
                description: "-/-"
            )
        }
        realmDetailManager.loadWeatherDetailFromAPI()
    }
    
    func loadWeather() {
        loadWeatherFromCache()
        loadWeatherFromAPI()
    }
    
    func loadWeatherFromCache () {
        let weatherDataCache = realmManager.realm.objects(WeatherDataLoader.self).last
        let weatherDetailDataCache = realmManager.realm.objects(WeatherDetail.self).last
        let weatherTownNameCache = realmManager.realm.objects(WeatherTownName.self).last
        
        if weatherDataCache != nil {
            DispatchQueue.main.async {
                self.delegate?.loaded(
                    currentTemperature: "\(weatherDataCache!.currentTemperature)",
                    feelsLikeTemperature: "\(weatherDataCache!.feelsLikeTemperature)",
                    minTemperature:"\(weatherDataCache!.minTemperature)",
                    maxTemperature:"\(weatherDataCache!.maxTemperature)",
                    humidity: "\(weatherDataCache!.humidity)",
                    pressure: "\(weatherDataCache!.pressure)",
                    nameTownLabel: weatherTownNameCache?.townName ?? ""
                )
                self.delegate?.loadedDetail(
                    description: "\(weatherDetailDataCache!.descriptionWeather)"
                )
            }
        }
    }

    func loadWeatherFromAPI () {
        let nameTownCache = realmManager.realm.objects(WeatherTownName.self).last
        let key = "bc8fc8363c5c900dd10131ef7dfefcbb"
        let townName = nameTownCache?.townName ?? ""
        let urlCurrentWeather = "https://api.openweathermap.org/data/2.5/weather?q=\(townName)&units=metric&appid=\(key)"
        let url = URL(string: urlCurrentWeather)
        
        let weatherAPIDataLoader = WeatherDataLoader()
        let weatherDetailAPILoader = WeatherDetail()

        //Сравнить data if данные есть, то ок, если нет, то вызов алерта
        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String: AnyObject]

                if let mainWeatherInfo = json["main"] {
                    weatherAPIDataLoader.currentTemperature = String(describing: mainWeatherInfo["temp"] as! Double)
                    weatherAPIDataLoader.feelsLikeTemperature = String(describing: mainWeatherInfo["feels_like"] as! Double)
                    weatherAPIDataLoader.minTemperature = String(describing: mainWeatherInfo["temp_min"] as! Double)
                    weatherAPIDataLoader.maxTemperature = String(describing: mainWeatherInfo["temp_max"] as! Double)
                    weatherAPIDataLoader.humidity = String(describing: mainWeatherInfo["humidity"] as! Int)
                    weatherAPIDataLoader.pressure = String(describing: mainWeatherInfo["pressure"] as! Int)
                    weatherAPIDataLoader.nameTown = townName
                }
                
                if let weatherWeatherinfoArray = json["weather"] as? NSArray {
                    let weatherWeatherinfo = weatherWeatherinfoArray[0] as? NSDictionary
                    weatherDetailAPILoader.descriptionWeather = weatherWeatherinfo?.value(forKey: "description") as! String
                }

                DispatchQueue.main.async {
                  self.delegate?.loaded(
                        currentTemperature: weatherAPIDataLoader.currentTemperature,
                        feelsLikeTemperature: weatherAPIDataLoader.feelsLikeTemperature,
                        minTemperature: weatherAPIDataLoader.minTemperature,
                        maxTemperature: weatherAPIDataLoader.maxTemperature,
                        humidity: weatherAPIDataLoader.humidity,
                        pressure: weatherAPIDataLoader.pressure,
                        nameTownLabel: weatherAPIDataLoader.nameTown
                  )
                    
                    self.realmManager.loadWeatherFromAPI()
                    
                    self.delegate?.loadedDetail(
                        description: weatherDetailAPILoader.descriptionWeather
                        )
                    self.realmDetailManager.loadWeatherDetailFromAPI()
                }
            }
            
            catch let jsonError {
                print(jsonError)
            }
        }
        task.resume()
    }
}
