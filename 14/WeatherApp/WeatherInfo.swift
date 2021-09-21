
import Foundation

class WeatherInfo {
    let temp: Float
    let feelsLike: Float
    
    init?(data: NSDictionary) {
    guard let mainNS = data["main"] as? NSDictionary,
        let temp = mainNS["temp"] as? Float,
        let feelsLike = mainNS["feels_like"] as? Float else {
                return nil
            }
        self.temp = temp
        self.feelsLike = feelsLike
    }
}
