import Foundation

public struct Quin {
    static let pathSession = "session"
    static let pathEvent = "event"
    static let pathTestEvent = "test-event"
    
    public static let sharedInstance = Quin()
    
    init() {
    }
    
    public func setConfig(apiKey: String, domain: String, enableLogging: Bool = false) {
        Http.setConfig(apiKey: apiKey, domain: domain)
        Logger.setConfig(enableLogging:enableLogging)
    }
    
    public func setUser(googleClientId: String) {
        _ = self.user()
    }
    
    public func track(event: Event, path: String = "event", completion:@escaping ActionHandler){
        guard let user = self.user() else{
            Logger.sharedInstance.log(msg:"quin track: user is nil")
            return
        }
        let req = event.setUser(user:user)
        guard let httpBody = try? JSONEncoder().encode(req) else {
            Logger.sharedInstance.log(msg:"quin track: encode error")
            return
        }
        Http.sharedInstance.post(path: path, body: httpBody){
            response in saveUser(response: response)
            completion(response?.content?.interaction)
        }
    }
    
    func user(googleClientId: String? = nil) -> User? {
        let user = UserStore.sharedInstance.load()
        if user == nil {
            let semaphore = DispatchSemaphore(value: 0)
            Http.sharedInstance.post(path: Quin.pathSession, body: nil){
                response in saveUser(response: response, googleClientId: googleClientId)
                semaphore.signal()
            }
            semaphore.wait()
        }
        return UserStore.sharedInstance.load()
    }
    
    func saveUser(response:Response?, googleClientId: String? = nil) {
        guard let user = response?.content?.user() else{
            Logger.sharedInstance.log(msg:"quin saveUser: response user is nil")
            return
        }
        var modifiedUser = user
        if googleClientId != nil {
           modifiedUser = user.withGoogleClientId(googleClientId: googleClientId!)
        }
        UserStore.sharedInstance.save(user: modifiedUser)
    }
}

extension Quin{
    public static let eCommerce = eCommerceImpl(instance: sharedInstance) as eCommerce
}

public protocol eCommerce{
    func sendTestEvent(completion:@escaping ActionHandler)
    func sendPageViewHomeEvent(completion:@escaping ActionHandler)
    func sendPageViewListingEvent(label:String, completion:@escaping ActionHandler)
    func sendAddToCartListingEvent(item:Item, quantity: Int, completion:@escaping ActionHandler)
    func sendFilterEvent(completion:@escaping ActionHandler)
    func sendPageViewDetailEvent(item:Item, completion:@escaping ActionHandler)
    func sendAddToCartDetailEvent(item:Item, quantity: Int, completion:@escaping ActionHandler)
    func sendAddToFavouritesEvent(item:Item, completion:@escaping ActionHandler)
    func sendProductInfoEvent(item:Item, completion:@escaping ActionHandler)
    func sendCommentsEvent(completion:@escaping ActionHandler)
    func sendQuantityDetailEvent(item:Item, quantity: Int, completion:@escaping ActionHandler)
    func sendQuantityCartEvent(item:Item, quantity: Int, completion:@escaping ActionHandler)
    func sendGoToCartEvent(completion:@escaping ActionHandler)
    func sendContinueShoppingEvent(completion:@escaping ActionHandler)
    func sendRemoveFromCartEvent(item:Item, quantity: Int, completion:@escaping ActionHandler)
    func sendEmptyCartEvent(completion:@escaping ActionHandler)
    func sendCheckoutEvent(completion:@escaping ActionHandler)
    func sendLoginEvent(completion:@escaping ActionHandler)
    func sendDiscountCodeEvent(discountCode:String, completion:@escaping ActionHandler)
    func sendDeliveryFeeEvent(completion:@escaping ActionHandler)
    func sendAdressEvent(completion:@escaping ActionHandler)
    func sendPaymentTypeEvent(completion:@escaping ActionHandler)
    func sendPurchaseCompletedEvent(totalBasketSize:Float, completion:@escaping ActionHandler)
    func sendAddToCartServiceEvent(item:Item, quantity: Int, completion:@escaping ActionHandler)
}

internal class eCommerceImpl: eCommerce{
    private let instance: Quin
    init(instance: Quin) {
        self.instance = instance
    }
    public func sendTestEvent(completion:@escaping ActionHandler){
        instance.track(event: Event.eCommerce.pageViewHomeEvent(), path: Quin.pathTestEvent, completion: completion)
    }
    public func sendPageViewHomeEvent(completion:@escaping ActionHandler){
        instance.track(event: Event.eCommerce.pageViewHomeEvent(), completion: completion)
    }
    public func sendPageViewListingEvent(label:String, completion:@escaping ActionHandler){
        instance.track(event: Event.eCommerce.pageViewListingEvent(label: label), completion: completion)
    }
    public func sendAddToCartListingEvent(item:Item, quantity: Int, completion:@escaping ActionHandler){
        instance.track(event: Event.eCommerce.addToCartListingEvent(item: item, quantity: quantity), completion: completion)
    }
    public func sendFilterEvent(completion:@escaping ActionHandler){
        instance.track(event: Event.eCommerce.filterEvent(), completion: completion)
    }
    public func sendPageViewDetailEvent(item:Item, completion:@escaping ActionHandler){
        instance.track(event: Event.eCommerce.pageViewDetailEvent(item:item), completion: completion)
    }
    public func sendAddToCartDetailEvent(item:Item, quantity: Int, completion:@escaping ActionHandler){
        instance.track(event: Event.eCommerce.addToCartDetailEvent(item: item, quantity: quantity), completion: completion)
    }
    public func sendAddToFavouritesEvent(item:Item, completion:@escaping ActionHandler){
        instance.track(event: Event.eCommerce.addToFavouritesEvent(item:item), completion: completion)
    }
    public func sendProductInfoEvent(item:Item, completion:@escaping ActionHandler){
        instance.track(event: Event.eCommerce.productInfoEvent(item: item), completion: completion)
    }
    public func sendCommentsEvent(completion:@escaping ActionHandler){
        instance.track(event: Event.eCommerce.commentsEvent(), completion: completion)
    }
    public func sendQuantityDetailEvent(item:Item, quantity: Int, completion:@escaping ActionHandler){
        instance.track(event: Event.eCommerce.quantityDetailEvent(item: item, quantity: quantity), completion: completion)
    }
    public func sendQuantityCartEvent(item:Item, quantity: Int, completion:@escaping ActionHandler){
        instance.track(event: Event.eCommerce.quantityCartEvent(item: item, quantity: quantity), completion: completion)
    }
    public func sendGoToCartEvent(completion:@escaping ActionHandler){
        instance.track(event: Event.eCommerce.goToCartEvent(), completion: completion)
    }
    public func sendContinueShoppingEvent(completion:@escaping ActionHandler){
        instance.track(event: Event.eCommerce.continueShoppingEvent(), completion: completion)
    }
    public func sendRemoveFromCartEvent(item:Item, quantity: Int, completion:@escaping ActionHandler){
        instance.track(event: Event.eCommerce.removeFromCartEvent(item: item, quantity: quantity), completion: completion)
    }
    public func sendEmptyCartEvent(completion:@escaping ActionHandler){
        instance.track(event: Event.eCommerce.emptyCartEvent(), completion: completion)
    }
    public func sendCheckoutEvent(completion:@escaping ActionHandler){
        instance.track(event: Event.eCommerce.checkoutEvent(), completion: completion)
    }
    public func sendLoginEvent(completion:@escaping ActionHandler){
        instance.track(event: Event.eCommerce.loginEvent(), completion: completion)
    }
    public func sendDiscountCodeEvent(discountCode:String, completion:@escaping ActionHandler){
        instance.track(event: Event.eCommerce.discountCodeEvent(discountCode: discountCode), completion: completion)
    }
    public func sendDeliveryFeeEvent(completion:@escaping ActionHandler){
        instance.track(event: Event.eCommerce.deliveryFeeEvent(), completion: completion)
    }
    public func sendAdressEvent(completion:@escaping ActionHandler){
        instance.track(event: Event.eCommerce.adressEvent(), completion: completion)
    }
    public func sendPaymentTypeEvent(completion:@escaping ActionHandler){
        instance.track(event: Event.eCommerce.paymentTypeEvent(), completion: completion)
    }
    public func sendPurchaseCompletedEvent(totalBasketSize:Float, completion:@escaping ActionHandler){
        instance.track(event: Event.eCommerce.purchaseCompletedEvent(totalBasketSize: totalBasketSize), completion: completion)
    }
    public func sendAddToCartServiceEvent(item:Item, quantity: Int, completion:@escaping ActionHandler){
        instance.track(event: Event.eCommerce.addToCartServiceEvent(item: item, quantity: quantity), completion: completion)
    }
}
