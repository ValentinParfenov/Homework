
import UIKit
import SwiftyJSON
import RealmSwift

class WeatherController: UIViewController {
    
    @IBOutlet weak var currentWeather: UILabel!
    @IBOutlet weak var feelsLikeWeather: UILabel!
    @IBOutlet weak var nameTown: UILabel!
    @IBOutlet weak var minT: UILabel!
    @IBOutlet weak var maxT: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let weatherLoader = WeatherLoader()
        weatherLoader.delegate = self
        weatherLoader.loadFirst()
        weatherLoader.loadWeather()
        weatherLoader.loadWeatherFromCache()
    }
}

extension WeatherController: LoadWeatherDelegate {
    func loaded (
        currentTemperature: String,
        feelsLikeTemperature: String,
        minTemperature: String,
        maxTemperature: String,
        nameTownLabel: String
    ) {
        currentWeather.text = currentTemperature
        feelsLikeWeather.text = feelsLikeTemperature
        minT.text = minTemperature
        maxT.text = maxTemperature
        nameTown.text = nameTownLabel
    }
}
