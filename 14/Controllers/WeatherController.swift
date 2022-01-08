
import UIKit

class WeatherController: UIViewController {
    
    @IBOutlet weak var currentWeather: UILabel!
    @IBOutlet weak var feelsLikeWeather: UILabel!
    @IBOutlet weak var nameTown: UILabel!
    @IBOutlet weak var minT: UILabel!
    @IBOutlet weak var maxT: UILabel!
    @IBOutlet weak var townTextField: UITextField!
    @IBOutlet weak var descriptionWeather: UILabel!
    @IBOutlet weak var pressureWeather: UILabel!
    @IBOutlet weak var humidityWeather: UILabel!
    @IBOutlet weak var iconWeatherImageView: UIImageView!
    @IBOutlet weak var dayNightImage: UIImageView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    
    let realmManager = RealmTownManager()
    let weatherLoader = WeatherLoader()
    let descriptionWeatherInfo = DescriptionWeatherInfo()

    @IBAction func townTextAction(_ sender: Any) {
        self.weatherLoader.town = self.townTextField.text ?? ""

        if nameTown.text != nil {
            nameTown.text = self.townTextField.text
        }

        realmManager.saveTownName(townName: self.weatherLoader.town)
        self.weatherLoader.loadWeatherFromAPI()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.weatherLoader.delegate = self
        self.weatherLoader.loadFirst()
        self.weatherLoader.loadWeather()
        setTime()
    }
}

extension WeatherController: LoadWeatherDelegate {
    
    func loaded (
        currentTemperature: String,
        feelsLikeTemperature: String,
        minTemperature: String,
        maxTemperature: String,
        humidity: String,
        pressure: String,
        nameTownLabel: String
    ) {
        currentWeather.text = "\(currentTemperature)º"
        feelsLikeWeather.text = "\(feelsLikeTemperature) ℃"
        minT.text = "\(minTemperature) ℃"
        maxT.text = "\(maxTemperature) ℃"
        pressureWeather.text = "\(pressure) mmHg"
        humidityWeather.text = "\(humidity) %"
        nameTown.text = nameTownLabel
    }
    
    func loadedDetail(description: String) {
        descriptionWeather.text = "\(description)"
        setIconWeather(description: description)
    }
    
    func setIconWeather (description: String) {
        
        if descriptionWeatherInfo.cloudsDescription.contains(description) {
            iconWeatherImageView.image = UIImage(named: "cloud")
        }
        if descriptionWeatherInfo.atmosphereDescription.contains(description) {
            iconWeatherImageView.image = UIImage(named: "winds")
        }
        if descriptionWeatherInfo.thunderDescription.contains(description) {
            iconWeatherImageView.image = UIImage(named: "storm")
        }
        if descriptionWeatherInfo.clearDescription.contains(description) {
            iconWeatherImageView.image = UIImage(named: "sunny")
        }
        if descriptionWeatherInfo.snowDescription.contains(description) {
            iconWeatherImageView.image = UIImage(named: "snowing")
        }
        if descriptionWeatherInfo.rainDescription.contains(description) {
            iconWeatherImageView.image = UIImage(named: "rain")
        }
    }
    
    func setTime() {
        let currentTime = DateFormatter.localizedString(from: Date(), dateStyle: .none, timeStyle: .short)
        timeLabel.text = currentTime
        if currentTime.contains("PM") {
            setNight()
        } else {
            setDay()
        }
    }
    
    func setGradientColor() {
        let colorGradient1 = UIColor(red: 163, green: 210, blue: 228, alpha: 0.5).cgColor
        let colorGradient2 = UIColor(red: 163, green: 28, blue: 205, alpha: 1.0).cgColor
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        gradientLayer.colors = [colorGradient1, colorGradient2]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 1.0)
        self.view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func setNight() {
        setGradientColor()
        backgroundImageView.alpha = 0.1
        dayNightImage.image = UIImage.init(named: "moon")
        
    }
    
    func setDay() {
        backgroundImageView.alpha = 0.9
        dayNightImage.image = UIImage.init(named: "sunny")
    }
}
