import XCTest
@testable import quinengine

final class eventTests: XCTestCase {
    let testApiKey = "test"
    let testDomain = "https://demo.quinengine.com"
    let testUserId = "test-user-id"
    let testUserToken = "test-user-token"
    let testGoogleClientId = "test-client-id"
    let userIdKey = "quin:userId"
    
    override func setUp() async throws {
        UserDefaults.standard.set(nil, forKey: userIdKey)
        Quin.sharedInstance.setConfig(apiKey: testApiKey, domain: testDomain, enableLogging:true)
        Quin.sharedInstance.setUser(googleClientId: testGoogleClientId)
    }
    
    func testStore() throws {
        let testUser = User(id: testUserId, token: testUserToken, googleClientId: testGoogleClientId)
        UserStore.sharedInstance.save(user: testUser)
        let ns = UserStore.sharedInstance.load()
        XCTAssert(testUser.id == ns?.id)
    }
    
    func testTrack() throws {
        let eventExpectation = XCTestExpectation(description: "track")
        Quin.eCommerce.sendTestEvent { action in
            print(action ?? "action is nil")
            eventExpectation.fulfill()
        }
        wait(for: [eventExpectation], timeout: 10)
    }
    
}


