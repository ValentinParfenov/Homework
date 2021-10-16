
import Foundation

class UserD {
    
static let shared = UserD()

    private let kUserNameFirstKey = "UserD.kUserNameFirstKey"
    private let kUserNameSecondKey = "UserD.kUserNameSecondKey"

    var firstName: String{
        set { UserDefaults.standard.set(newValue, forKey: kUserNameFirstKey) }
        get { return UserDefaults.standard.string(forKey: kUserNameFirstKey) ?? "" }
    }
    
    var secondName: String{
        set { UserDefaults.standard.set(newValue, forKey: kUserNameSecondKey) }
        get { return UserDefaults.standard.string(forKey: kUserNameSecondKey) ?? "" }
    }
}

