import Foundation

struct User: Codable {
    internal init(id: String, token: String,googleClientId: String) {
        self.id = id
        self.token = token
        self.googleClientId = googleClientId
    }
    
    internal func withGoogleClientId(googleClientId:String) -> User{
        var user = self
        user.googleClientId = googleClientId
        return user
    }
    
    var id: String
    var token: String
    var googleClientId: String
}
