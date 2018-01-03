import XCTest
@testable import Light
import Shallows

struct DecodableBox<Boxed : Decodable> : Decodable {
    
    let values: [Boxed]
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.values = try container.decode([Boxed].self)
    }
    
}

struct Currency : Decodable {
    let id: String
    let name: String
    let price_usd: String
}

class LightTests: XCTestCase {
    
    func testWebAPI() throws {
        let bitcoinAPI = WebAPI(baseURL: URL.init(string: "https://api.coinmarketcap.com/v1/")!,
                                urlSessionConfiguration: .ephemeral)
            .singleKey("ticker/bitcoin/")
            .mapJSONObject(DecodableBox<Currency>.self)
            .mapValues({ try $0.values.first.unwrap() })
            .makeSyncStorage()
        let bitcoin = try bitcoinAPI.retrieve()
        XCTAssertEqual(bitcoin.id, "bitcoin")
        XCTAssertEqual(bitcoin.name, "Bitcoin")
        print(bitcoin.price_usd)
    }
    
}
