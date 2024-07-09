# Quin Audience Engine iOS SDK

![image (1)](https://user-images.githubusercontent.com/112876992/222405013-487c28f7-5bfc-4265-8f0c-1b8a890101f7.png)

***

1. What is Quin Quin Audience Engine ?

Quin Audience Engine is a real-time digital customer analytics tool that helps e-commerce websites predict visitors' behavior after only 3-clicks, and engage them in real-time.

2. What is Quin Audience Engine iOS SDK ?

Quin Audience Engine iOS SDK is used to create and send events to the Quin AI backend. In result of tracked events, you will get actions.

***

## SETUP

Quin Audience Engine iOS SDK uses github for distribution. In order to add this library to your project first add it to your project dependencies by following lines. 

```swift
dependencies: [
    ...
    .package(url: "https://github.com/quinai/ios-sdk.git", from: <version-string>),
]
```

Then import it to your project by following lines.

```swift
import Quin
```

After importing the library you need to initialize it before sending events. In order to initialize sdk first set configs and thens set the user with the following lines.

```swift
Quin.sharedInstance.setConfig(apiKey: "api-key", domain: "domain", enableLogging: false)
Quin.sharedInstance.setUser(googleClientId: "client-id") 
```

> enableLogging option is used to print logs to the console. 

After the initialization is done, you can start sending events.

***

## Structures

### Item
The item structure holds the information about the item such as name, category, price etc. Item class is sent inside event to give item information of that event. 

```swift
Item {
 id: String,
 name: String,
 category: String,
 price: Decimal,
 currency: String,
}
```

Here is an example of Item creation.

```swift
Item(id: "1250353863",
 name: "wooden chair",
 category: "Garden",
 price: 39.99,
 currency: "USD"
```

### Action
Action is the structure that tracker or send functions returns. Action holds the properties such as category, promotion code, display etc.
Resulted action which has the following structure can be used to show pop-ups on the screen.

```kotlin
Action {
   actionId: String?
   actionType: String?
   category: String?
   promotionCode: String?
   custom: Boolean?
   display: Display?
   html: String?
}
```

### Display
Display structure holds the actions display properties that is required to draw the pop-up.

```kotlin
Display {
    paddle: Boolean?
    position: String?
    fields: Dictionary<String,DisplayField>?
    properties: Dictionary<String,DisplayProperty>?
}
```

### DisplayField
DisplayField structure holds the field entity of an display object.

```kotlin
DisplayField {
    name: String?
    text: String?
    color: String?
    url: String?
    position: String?
}
```

### DisplayProperty
DisplayProperty structure holds the property entity of an display object.

```kotlin
DisplayProperty {
    propertyType: String?
    label: String?
    placeholder: String?
    required: String?
    options: Array<String>?
}
```

***

SDK allows us to send events and recieve actions in result. There are 2 ways to send events to the Quin AI's backend service which are using predefined send event functions and creating custom events and sending them manually. These sending functions take a completion parameter as type of ActionHandler which is simply:

```swift
typealias ActionHandler = (Action?) -> Void
```

You can pass completions to those functions and use resulted actions in your code.

### Sending Predefined events

In Quin we have a set of predefined event sender functions that require minimum set of data for the backend such as widely known e-commerce events.
Functions that send predefined events by Quin SDK are listed below.

```swift
sendPageViewHomeEvent(completion:@escaping ActionHandler)
sendPageViewListingEvent(label: String, completion:@escaping ActionHandler)
sendPageViewListingWithCategoryIdEvent(label:String, categoryId: String, completion:@escaping ActionHandler)
sendAddToCartListingEvent(item: Item?, quantity: Int, completion:@escaping ActionHandler)
sendFilterEvent(completion:@escaping ActionHandler)
sendPageViewDetailEvent(item: Item?, completion:@escaping ActionHandler)
sendAddToCartDetailEvent(item: Item?, quantity: Int, completion:@escaping ActionHandler)
sendAddToFavouritesEvent(item: Item?, completion:@escaping ActionHandler)
sendProductInfoEvent(item: Item?, completion:@escaping ActionHandler)
sendCommentsEvent(completion:@escaping ActionHandler)
sendQuantityDetailEvent(item: Item?, quantity: Int, completion:@escaping ActionHandler)
sendQuantityCartEvent(item: Item?, quantity: Int, completion:@escaping ActionHandler)
sendGoToCartEvent(completion:@escaping ActionHandler)
sendContinueShoppingEvent(completion:@escaping ActionHandler)
sendRemoveFromCartEvent(item: Item?, quantity: Int, completion:@escaping ActionHandler)
sendEmptyCartEvent(completion:@escaping ActionHandler)
sendCheckoutEvent(completion:@escaping ActionHandler)
sendLoginEvent(completion:@escaping ActionHandler)
sendDiscountCodeEvent(discountCode: String, completion:@escaping ActionHandler)
sendDeliveryFeeEvent(completion:@escaping ActionHandler)
sendAddressEvent(completion:@escaping ActionHandler)
sendPaymentTypeEvent(completion:@escaping ActionHandler)
sendPurchaseCompletedEvent(totalBasketSize: Float, completion:@escaping ActionHandler)
sendAddToCartServiceEvent(item: Item?, quantity: Int, completion:@escaping ActionHandler)
```

All predefined functions above are defined inside e-commerce interface to create an abstraction to users. You can simply send events from interface variable inside Quin singleton class. Following lines explain how to use them. 

```swift
Quin.eCommerce.sendFilterEvent() { action in
    print(action ?? "action is nil")
}
```

### Sending Custom events

In order to send custom events first you need to create event to be sent. We have declared some event functions that returns widely known e-commerce events. These events are listed below. 

```swift
pageViewHomeEvent()
pageViewListingEvent(label: String)
pageViewListingWithCategoryIdEvent(label:String, categoryId: String)
addToCartListingEvent(item: Item?, quantity: Int)
filterEvent()
pageViewDetailEvent(item: Item)
addToCartDetailEvent(item: Item?, quantity: Int)
addToFavouritesEvent(item: Item?)
productInfoEvent(item: Item?)
deliveryInfoEvent(item: Item?)    
commentsEvent()
quantityDetailEvent(item: Item?, quantity: Int)
quantityCartEvent(item: Item?, quantity: Int)
goToCartEvent()
continueShoppingEvent()
removeFromCartEvent(item: Item?, quantity: Int)
emptyCartEvent()
checkoutEvent()
loginEvent()
discountCodeEvent(discountCode: String)
deliveryFeeEvent()
adressEvent()
paymentTypeEvent()
purchaseCompletedEvent(totalBasketSize: Int)
addToCartServiceEvent(item: Item?, quantity: Int)
```

All predefined functions above are defined inside e-commerce interface to create an abstraction to users. You can simply create events from interface variable inside Event class. Following lines explain how to use them. 

* Returns Event structure with filled with home pageview data.
```swift
let event = Event.eCommerce.pageViewHomeEvent()
```

* Takes item as Item struct and quantity as integer. Returns Event structure filled with add to cart, item, and quantity data.
> Item can be nil.
```kotlin
let event = Event.eCommerce.addToCartListingEvent(item: <Item>, quantity: 2)
```

Also adding custom attributes to those events are possible by function ```withCustomAttribute(key: String, value: String)```. Following example shows how to use it.

```swift
val event = Event.eCommerce.pageViewHomeEvent().withCustomAttribute(key: "color", color: "red")
```

After creating the event you can send them to the Quin services using ```track(event: Event, completion:@escaping ActionHandler)```. Following line shows how to use it.

```swift
let event = Event.eCommerce.pageViewHomeEvent()
Quin.track(event = event) { action in
    print(action ?? "action is nil")
}
```

If those functions does not satisfy your use cases, you can create custom events and send them to Quin services again using track function. Following example demonstrates how to create custom events and send it. 

```swift
let item = Item("id", "name", "cat","cat-id", 5.00, "usd")
let event = Event(category : "\(EventCategory.home)",
                  action : "\(EventAction.click)", 
                  label : "custom label", 
                  url : "ex-screen", 
                  item : item)
Quin.track(event = event) { action in
    print(action ?? "action is nil")
}
```

***

## Quick Start

After adding library to your project and setting up initialization, we have declared a test function that sends a test event to Quin services, and returns a mock Action filled with below data.


```swift
Action: {
    actionId:      "d3da1e3c5b1f8159",
    actionType:    "upsell",
    category:      "Garden > Storage > Storage Wardrobe",
    categoryId:    "10051-54541"
    promotionCode: "QTK1-4RSS-RR38-FTGR",
    custom:        false,
    display: {
        paddle:   true,
    position: "center",
        fields: {
            "actionButton": {
        Name:     "actionButton",
        Text:     "Copy",
        Color:    "#f59f1d",
        Url:      "",
        Position: "",
        },
            "dismissButton": {
        Name:     "dismissButton",
        Text:     "Close",
        Color:    "#ffffff",
        Url:      "",
        Position: "",
        },
        "image": {
        Name:     "image",
        Text:     "",
        Color:    "",
        Url:      "https://cdn.thequin.ai/act/20221221-efab69f589f50a1a62ae5d4a2c785e29.png",
        Position: "top",
        },
            "background": {
        Name:     "background",
        Text:     "",
        Color:    "#ffe8b3",
        Url:      "",
        Position: "",
        },
            "description": {
        Name:     "description",
        Text:     "Don't forget to use your %10 discount code. You can get a maximum discount of $100",
        Color:    "#000000",
        Url:      "",
        Position: "",
        }
        },
    properties: nil
    }
}
```


You can use this action as a reference and use it to draw pop-ups etc. In order to send test event you can use Quin singleton's ```test(event: Event, completion:@escaping ActionHandler)```function. Following lines shows how to do this.

```swift
let item = Item(
    id : "testId",
    name : "testName",
    category : "testCategory",
    categoryId: "test-category-id"
    price : 93.8,
    currency : "TRY")
val event = Event(
    category : "cat",
    action : "act",
    label : "lab",
    url : "ex-screen",
    item : item)
    .withCustomAttribute(key: "color", value: "blue")
Quin.test(event: event) { action in
    // Use action variable here
}
```

***

## Troubleshooting

For any problems or further questions you can contact us with from hello@quinengine.com address.  

