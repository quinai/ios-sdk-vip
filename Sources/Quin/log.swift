import Foundation

struct Logger{
    static var configuration = LogConfiguration()
    static let sharedInstance = Logger()
    init() {
    }
    static func setConfig(enableLogging:Bool){
        configuration.enableLogging = enableLogging
    }
    func log(msg:String){
        if Logger.configuration.enableLogging ?? false {
            print(msg)
        }
    }
}
