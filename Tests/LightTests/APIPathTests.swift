import XCTest
@testable import Light

class APIPathTests: XCTestCase {
    
    func testPath1() {
        let apiPath = APIPath(components: ["user", "15"])
        XCTAssertEqual(apiPath.rawValue, "user/15")
    }
    
    func testAddition() {
        let added: APIPath = "user" + "15"
        XCTAssertEqual(added, APIPath.init(rawValue: "user/15"))
    }
    
}
