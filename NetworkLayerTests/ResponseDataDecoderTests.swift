//
//  Created by Dilshod Zopirov on 8/1/25.
//

import XCTest
@testable import NetworkLayer

final class ResponseDataDecoderTests: XCTestCase {
    func test_none2xxHttpStatusCodeResponses_throwsInvalidStatusCodeError() throws {
        let none2xxStatusCodes = [401, 404, 500, 501]
        for none2xxStatusCode in none2xxStatusCodes {
            let responseData = makeResponseData(statusCode: none2xxStatusCode)
            do {
                let _: MockDTO = try ResponseDataDecoder.map(responseData)
                XCTFail("Expected error, got success")
            } catch {
                XCTAssertEqual(
                    (error as? HttpClientError),
                    HttpClientError.invalidStatusCode(none2xxStatusCode, responseData.data)
                )
            }
        }
    }
    
    func test_invalidJsonData_throwsDecodingError() throws {
        let responseData = makeResponseData(statusCode: 200, json: "invalid-json")
        do {
            let _: MockDTO = try ResponseDataDecoder.map(responseData)
            XCTFail("Expected error, got success")
        } catch {
            XCTAssertTrue(error is DecodingError)
        }
    }
    
    func test_validJsonData_decodesSuccessfully() throws {
        let responseData = makeResponseData(statusCode: 200)
        let dto: MockDTO = try ResponseDataDecoder.map(responseData)
        
        XCTAssertEqual(dto, MockDTO(name: "Test"))
    }
    
    //MARK: Helpers
    
    private func makeResponseData(
        statusCode: Int,
        json: String = "{\"name\":\"Test\"}"
    ) -> ResponseData {
        let response = HTTPURLResponse(
            url: URL(string: "https://any-url.com")!,
            statusCode: statusCode,
            httpVersion: nil,
            headerFields: nil
        )!
        let data = json.data(using: .utf8)!
        return ResponseData(data: data, response: response)
    }
}

struct MockDTO: Decodable, Equatable {
    let name: String
}
