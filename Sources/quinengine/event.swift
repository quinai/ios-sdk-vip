import Foundation

public struct Event: Encodable {
    public init(category: String,
                  action: String,
                  label: String = "",
                  url: String = "",
                  item: Item? = nil) {
        self.userId = ""
        self.token = ""
        self.googleClientId = ""
        self.platform = "ios"
        self.category = category
        self.action = action
        self.label = label
        self.url = url
        self.item = item
        self.customAttributes = [:]
    }
    
    private(set) public var userId: String
    private(set) public var token: String
    private(set) public var googleClientId: String
    public let platform: String
    public let category: String
    public let action: String
    public let label: String
    public let url: String
    public let item: Item?
    private(set) public var customAttributes : Dictionary<String,String>
    
    internal func setUser(user:User) -> Event {
        var newEvent = self
        newEvent.userId = user.id
        newEvent.token = user.token
        newEvent.googleClientId = user.googleClientId
        return newEvent
    }
    
    public func withCustomAttribute(key:String, value:String) -> Event {
        var customAttribute = self.customAttributes
        customAttribute[key] = value
        var newEvent = self
        newEvent.customAttributes = customAttribute
        return newEvent
    }
}

extension Event{
    public static let eCommerce = eCommerceEventImpl() as eCommerceEvent
}

enum EventCategory {
    case home,
         listing,
         detail,
         cart,
         checkout,
         service,
         interaction,
         reaction
}

enum EventLabel {
    case addtobasket,
         addtofavourites,
         productinfo,
         deliveryinfo,
         comments,
         quantity,
         gotocart,
         continueshopping,
         removefromcart,
         emptycart,
         checkout,
         login,
         discountcode,
         deliveryfee,
         adress,
         paymenttype,
         purchasecompleted
}

enum EventAction {
    case pageview,
         click
}

internal class eCommerceEventImpl : eCommerceEvent {
    func pageViewHomeEvent() -> Event{
        return Event(category:"\(EventCategory.home)",
                action: "\(EventAction.pageview)")
    }
    func pageViewListingEvent(label:String, categoryId: String) -> Event{
        return Event(category:"\(EventCategory.listing)",
                     action: "\(EventAction.pageview)",
                     label: label).withCustomAttribute(key: "categoryId", value: categoryId)
    }
    func addToCartListingEvent(item: Item, quantity: Int) -> Event{
        return Event(category:"\(EventCategory.listing)",
                     action:"\(EventAction.click)",
                     label: "\(EventLabel.addtobasket)",
                     item: item).withCustomAttribute(key: "quantity", value: quantity.description)
    }
    func filterEvent() -> Event{
        return Event(category:"\(EventCategory.listing)",
                     action: "\(EventAction.click)")
    }
    // Detail
    func pageViewDetailEvent(item: Item) -> Event{
        return Event(category:"\(EventCategory.detail)",
                     action: "\(EventAction.pageview)",
                     label: item.getCategory(),
                     item: item).withCustomAttribute(key: "categoryId", value: item.getCategoryId())
    }
    func addToCartDetailEvent(item: Item, quantity: Int) -> Event{
        return Event(category:"\(EventCategory.detail)",
                     action: "\(EventAction.click)",
                     label: "\(EventLabel.addtobasket)",
                     item: item).withCustomAttribute(key: "quantity", value: quantity.description)
    }
    func addToFavouritesEvent(item: Item) -> Event{
        return Event(category:"\(EventCategory.detail)",
                     action: "\(EventAction.click)",
                     label: "\(EventLabel.addtofavourites)",
                     item: item)
    }
    func productInfoEvent(item: Item) -> Event{
        return Event(category:"\(EventCategory.detail)",
                     action: "\(EventAction.click)",
                     label: "\(EventLabel.productinfo)",
                     item: item)
    }
    func deliveryInfoEvent(item: Item) -> Event{
        return Event(category:"\(EventCategory.detail)",
                     action: "\(EventAction.click)",
                     label: "\(EventLabel.deliveryinfo)",
                     item: item)
    }
    func commentsEvent() -> Event{
        return Event(category:"\(EventCategory.detail)",
                     action: "\(EventAction.click)",
                     label: "\(EventLabel.comments)")
    }
    func quantityDetailEvent(item: Item, quantity: Int) -> Event{
        return Event(category:"\(EventCategory.detail)",
                     action: "\(EventAction.click)",
                     label: "\(EventLabel.quantity)",
                     item: item).withCustomAttribute(key: "quantity", value: quantity.description)
    }
    // Cart
    func quantityCartEvent(item: Item, quantity: Int) -> Event{
        return Event(category:"\(EventCategory.cart)",
                     action: "\(EventAction.click)",
                     label: "\(EventLabel.quantity)",
                     item: item).withCustomAttribute(key: "quantity", value: quantity.description)
    }
    func goToCartEvent() -> Event{
        return Event(category:"\(EventCategory.cart)",
                     action: "\(EventAction.click)",
                     label: "\(EventLabel.gotocart)")
    }
    func continueShoppingEvent() -> Event{
        return Event(category:"\(EventCategory.cart)",
                     action: "\(EventAction.click)",
                     label: "\(EventLabel.continueshopping)")
    }
    func removeFromCartEvent(item: Item, quantity: Int) -> Event{
        return Event(category:"\(EventCategory.cart)",
                     action:"\(EventAction.click)",
                     label: "\(EventLabel.removefromcart)",
                     item: item).withCustomAttribute(key: "quantity", value: quantity.description)
    }
    func emptyCartEvent() -> Event{
        return Event(category:"\(EventCategory.cart)",
                     action: "\(EventAction.click)",
                     label: "\(EventLabel.emptycart)")
    }
    func checkoutEvent() -> Event{
        return Event(category:"\(EventCategory.cart)",
                     action: "\(EventAction.click)",
                     label: "\(EventLabel.checkout)")
    }
    func loginEvent() -> Event{
        return Event(category:"\(EventCategory.checkout)",
                     action: "\(EventAction.click)",
                     label: "\(EventLabel.login)")
    }
    func discountCodeEvent(discountCode: String) -> Event{
        return Event(category:"\(EventCategory.checkout)",
                     action: "\(EventAction.click)",
                     label: "\(EventLabel.discountcode)")
        .withCustomAttribute(key: "discountcode", value: discountCode)
    }
    func deliveryFeeEvent() -> Event{
        return Event(category:"\(EventCategory.checkout)",
                     action: "\(EventAction.click)",
                     label: "\(EventLabel.deliveryfee)")
    }
    func adressEvent() -> Event{
        return Event(category:"\(EventCategory.checkout)",
                     action: "\(EventAction.click)",
                     label: "\(EventLabel.adress)")
    }
    func paymentTypeEvent() -> Event{
        return Event(category:"\(EventCategory.checkout)",
                     action: "\(EventAction.click)",
                     label: "\(EventLabel.paymenttype)")
    }
    func purchaseCompletedEvent(totalBasketSize: Float) -> Event{
        return Event(category:"\(EventCategory.checkout)",
                     action: "\(EventAction.click)",
                     label: "\(EventLabel.purchasecompleted)")
        .withCustomAttribute(key: "totalbasketsize", value: totalBasketSize.description)
    }
    func addToCartServiceEvent(item: Item, quantity: Int) -> Event{
        return Event(category:"\(EventCategory.service)",
                     action: "\(EventAction.click)",
                     label: "\(EventLabel.addtobasket)",
                     item: item).withCustomAttribute(key: "quantity", value: quantity.description)
    }
}


public protocol eCommerceEvent{
    func pageViewHomeEvent() -> Event
    func pageViewListingEvent(label:String, categoryId: String) -> Event
    func addToCartListingEvent(item: Item, quantity: Int) -> Event
    func filterEvent() -> Event
    func pageViewDetailEvent(item: Item) -> Event
    func addToCartDetailEvent(item: Item, quantity: Int) -> Event
    func addToFavouritesEvent(item: Item) -> Event
    func productInfoEvent(item: Item) -> Event
    func deliveryInfoEvent(item: Item) -> Event
    func commentsEvent() -> Event
    func quantityDetailEvent(item: Item, quantity: Int) -> Event
    func quantityCartEvent(item: Item, quantity: Int) -> Event
    func goToCartEvent() -> Event
    func continueShoppingEvent() -> Event
    func removeFromCartEvent(item: Item, quantity: Int) -> Event
    func emptyCartEvent() -> Event
    func checkoutEvent() -> Event
    func loginEvent() -> Event
    func discountCodeEvent(discountCode: String) -> Event
    func deliveryFeeEvent() -> Event
    func adressEvent() -> Event
    func paymentTypeEvent() -> Event
    func purchaseCompletedEvent(totalBasketSize: Float) -> Event
    func addToCartServiceEvent(item: Item, quantity: Int) -> Event
}
