
import XCTest
@testable import ElastosCarrier

class ElastosCarrierTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    /// Bounded self info: a string longer than its fixed C field is cut to
    /// fit (at a character boundary) and never runs into the next field.
    func testUserInfoFieldsAreBounded() {
        let info = CarrierUserInfo()
        info.userId = "7UNFCSSc1111111111111111111111111111111111"
        info.name = "a" + String(repeating: "\u{540D}", count: 40)        // 121 bytes, limit 63
        info.briefDescription = String(repeating: "d", count: 500)       // limit 127
        info.gender = String(repeating: "g", count: 100)                 // limit 31
        info.phone = "An iPhone with quite a long name 16 Pro"           // 39 bytes, limit 31
        info.email = nil                                                 // nothing may spill into it
        info.region = String(repeating: "r", count: 500)                 // last field, limit 127

        let c = convertCarrierUserInfoToCUserInfo(info)
        let back = convertCUserInfoToCarrierUserInfo(c)

        XCTAssertEqual(back.userId, info.userId)
        XCTAssertEqual(back.name, "a" + String(repeating: "\u{540D}", count: 20))   // 61 bytes: whole characters only
        XCTAssertEqual(back.briefDescription, String(repeating: "d", count: 127))
        XCTAssertEqual(back.gender, String(repeating: "g", count: 31))
        XCTAssertEqual(back.phone, "An iPhone with quite a long nam")
        XCTAssertEqual(back.email, "")
        XCTAssertEqual(back.region, String(repeating: "r", count: 127))
    }

    func testShortFieldsAreUnchanged() {
        let info = CarrierUserInfo()
        info.name = "Wei"
        info.phone = "iPhone"
        info.email = "someone@example.org"

        let back = convertCUserInfoToCarrierUserInfo(convertCarrierUserInfoToCUserInfo(info))

        XCTAssertEqual(back.name, "Wei")
        XCTAssertEqual(back.phone, "iPhone")
        XCTAssertEqual(back.email, "someone@example.org")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
