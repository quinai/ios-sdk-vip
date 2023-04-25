import Foundation

public typealias ActionHandler = (Action?) -> Void

public enum ActionType: Decodable {
    case  form, discount, upsell, badge, information
}

public enum ActionPosition: Decodable {
    case center, topLeft, topRight, bottomLeft, bottomRight
}

public struct Action: Decodable {
    public let actionId: String?
    public let actionType:String?
    public let category: String?
    public let promotionCode: String?
    public let custom: Bool?
    public let display: Display?
    public let html : String?
}

public struct Display: Decodable {
    public let paddle: Bool?
    public let position: String?
    public let fields:  Dictionary<String,DisplayField>?
    public let properties: Dictionary<String,DisplayProperty>?
}

public struct DisplayField: Decodable {
    public let name: String?
    public let text: String?
    public let color: String?
    public let url: String?
    public let position: String?
}

public struct DisplayProperty: Decodable {
    public let propertyType: String?
    public let label: String?
    public let placeholder: String?
    public let required: String?
    public let options: Array<String>?
}
