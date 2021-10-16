
import Foundation
import RealmSwift

class TasksList: Object {
    @objc dynamic var task = ""
    @objc dynamic var completed = false
}

class WeatherDataLoader: Object {
    @objc dynamic var currentTemperature = ""
    @objc dynamic var feelsLikeTemperature = ""
    @objc dynamic var nameTown = ""
    @objc dynamic var minTemperature = ""
    @objc dynamic var maxTemperature = ""
}

class RealmManager {
    let realm = try! Realm()
    var data = [TasksList]()
    var items: Results<TasksList>!
    
    func addTask (_ title: String) {
        let task = TasksList()
        task.task = title
        try! self.realm.write {
            self.realm.add(task)
        }
    }
    
    func deleteTask (_ tableView: UITableView, forRowAt indexPath: IndexPath) {
        try! self.realm.write {
            self.realm.delete(self.items[indexPath.row])
            tableView.reloadData()
        }
    }
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
