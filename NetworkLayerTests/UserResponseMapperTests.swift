//
//  Created by Dilshod Zopirov on 8/1/25.
//

import XCTest
@testable import NetworkLayer

final class UserResponseMapperTests: XCTestCase {
    func test_nilUserIdValue_throwsInvalidResponse() throws {
        let responseData = makeResponseData(
            statusCode: 200,
            json: makeJson(id: nil, name: "Jane Doe")
        )
        do {
            _ = try UserResponseMapper.map(responseData)
            XCTFail("Expected error, got success")
        } catch {
            XCTAssertEqual((error as? HttpClientError), HttpClientError.invalidResponse)
        }
    }
    
    func test_nilFullNameValue_throwsInvalidResponse() throws {
        let responseData = makeResponseData(
            statusCode: 200,
            json: makeJson(id: 42, name: nil)
        )
        do {
            _ = try UserResponseMapper.map(responseData)
            XCTFail("Expected error, got success")
        } catch {
            XCTAssertEqual((error as? HttpClientError), HttpClientError.invalidResponse)
        }
    }
    
    func test_rightJson_returnsSuccess() throws {
        let responseData = makeResponseData(
            statusCode: 200,
            json: makeJson(id: 42, name: "Jane Doe")
        )
        let user = try UserResponseMapper.map(responseData)
        XCTAssertEqual(user, User(id: 42, name: "Jane Doe"))
    }
    
    //MARK: Helpers
    
    private func makeResponseData(statusCode: Int, json: String) -> ResponseData {
        let response = HTTPURLResponse(
            url: URL(string: "https://any-url.com")!,
            statusCode: statusCode,
            httpVersion: nil,
            headerFields: nil
        )!
        let data = json.data(using: .utf8)!
        return ResponseData(data: data, response: response)
    }
    
    private func makeJson(id: Int?, name: String?) -> String {
        let idValue = id.map(String.init) ?? "null"
        let nameValue = name.map { "\"\($0)\"" } ?? "null"
        
        return """
            {
                "user_id": \(idValue),
                "full_name": \(nameValue)
            }
        """
    }
}
