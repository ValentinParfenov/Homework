
import Foundation
import RealmSwift

class WeatherDataLoader: Object {
    @Persisted dynamic var currentTemperature = ""
    @Persisted dynamic var feelsLikeTemperature = ""
    @Persisted dynamic var nameTown = ""
    @Persisted dynamic var minTemperature = ""
    @Persisted dynamic var maxTemperature = ""
    @Persisted dynamic var pressure = ""
    @Persisted dynamic var humidity = ""
}

class WeatherDetail: Object {
    @Persisted dynamic var descriptionWeather = ""
}

class WeatherTownName: Object {
    @Persisted dynamic var townName = ""
}

class RealmWeatherManager {
    let realm = try! Realm()
    var dataW = [WeatherDataLoader]()
    var weatherData: Results<WeatherDataLoader>!
    
    func loadWeatherFirst () {
        let weatherLoadFirst = realm.objects(WeatherDataLoader.self)
        try! self.realm.write {
            self.realm.add(weatherLoadFirst)
        }
    }
    
    func loadWeatherFromAPI () {
        let weatherAPIDataLoader = WeatherDataLoader()
            try! self.realm.write {
                self.realm.add(weatherAPIDataLoader)
        }
    }
}

class RealmDetailWeather {
    let realm = try! Realm()
    var dataWD = [WeatherDetail]()
    var weatherDetailData: Results<WeatherDetail>!
    
    func loadWeatherDetailFromAPI () {
        let weatherDetailAPILoader = WeatherDetail()
            try! self.realm.write {
                self.realm.add(weatherDetailAPILoader)
        }
    }
}
    
class RealmTownManager {
    let realm = try! Realm()
    var dataW = [WeatherTownName]()
    var townData: Results<WeatherTownName>!

    func saveTownName (townName: String) {
        let weatherTownName = WeatherTownName()
        weatherTownName.townName = townName

        try! self.realm.write {
            self.realm.add(weatherTownName)
        }
    }
}
