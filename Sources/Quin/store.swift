import Foundation

struct UserStore {
    let keyUserId: String = "quin:userId"
    let keyToken: String = "quin:token"
    let keyGcid: String = "quin:gcid"
    
    static let sharedInstance = UserStore()
    
    init(){}
    
    func load() -> User? {
        let defaults = UserDefaults.standard
        guard let userId = defaults.string(forKey: keyUserId) else {
            Logger.sharedInstance.log(msg:"quin store load: userId is empty")
            return nil
        }
        guard let token = defaults.string(forKey: keyToken) else {
            Logger.sharedInstance.log(msg:"quin store load: token is empty")
            return nil
        }
        let gcid = defaults.string(forKey: keyGcid) ?? ""
        return User(id: userId, token: token, googleClientId: gcid)
        
    }
    
    func save(user: User) -> Void {
        let defaults = UserDefaults.standard
        defaults.set(user.id, forKey: keyUserId)
        defaults.set(user.token, forKey: keyToken)
        if (!user.googleClientId.isEmpty) {
            defaults.set(user.googleClientId, forKey: keyGcid)
        }
        defaults.synchronize()
    }
    
}

