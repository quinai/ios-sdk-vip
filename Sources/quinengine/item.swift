import Foundation

public struct Item: Encodable {
    public init(id: String,
                  name: String,
                  category: String,
                categoryId: String,
                  price: Decimal,
                  currency: String,
                  customAttributes : Dictionary<String,String> = [:]
    ) {
        self.id = id
        self.name = name
        self.category = category
        self.categoryId = categoryId
        self.price = price
        self.currency = currency
        self.customAttributes = customAttributes
    }
    
    public let id: String
    public let name: String
    public let category: String
    public let categoryId: String
    public let price: Decimal
    public let currency : String
    private(set) public var customAttributes : Dictionary<String,String>
    
    internal func getCategory() -> String {
        return self.category
    }
    
    internal func getCategoryId() -> String{
        return self.categoryId
    }
    
    public func withCustomAttribute(key:String, value:String) -> Item {
        var customAttribute = self.customAttributes
        customAttribute[key] = value
        var newItem = self
        newItem.customAttributes = customAttribute
        return newItem
    }
}


