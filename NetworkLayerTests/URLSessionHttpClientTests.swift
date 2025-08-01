//
//  Created by Dilshod Zopirov on 7/30/25.
//

import XCTest
@testable import NetworkLayer

final class URLSessionHttpClientTests: XCTestCase {
    override func setUp() {
        super.setUp()
        URLProtocolStub.startInterceptingRequests()
    }
    
    override func tearDown() {
        URLProtocolStub.stopInterceptingRequests()
        super.tearDown()
    }
    
    func test_successfulRequest_returnsDataAndResponse() async throws {
        let expectedData = Data("any-data".utf8)
        let expectedResponse = HTTPURLResponse(
            url: anyURL(),
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )!
        
        
        URLProtocolStub.stub(response: expectedResponse, data: expectedData, error: nil)
        
        let sut = makeSUT()
        let urlRequest = URLRequest(url: anyURL())
        
        let responseData = try await sut.request(urlRequest)
        
        XCTAssertEqual(responseData.data, expectedData)
        XCTAssertEqual(responseData.response.url, expectedResponse.url)
        XCTAssertEqual(responseData.response.statusCode, expectedResponse.statusCode)
    }
    
    func test_emptyBodyWith200_returnsEmtyData() async throws {
        let expectedResponse = HTTPURLResponse(
            url: anyURL(),
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )
        
        URLProtocolStub.stub(response: expectedResponse, data: nil, error: nil)
        
        let sut = makeSUT()
        let urlRequest = URLRequest(url: anyURL())
        
        let responseData = try await sut.request(urlRequest)
        
        XCTAssertEqual(responseData.data, Data())
        XCTAssertEqual(responseData.response.statusCode, 200)
    }
    
    func test_networkError_throwsURLError() async throws {
        let expectedError = URLError(.timedOut)
        URLProtocolStub.stub(response: nil, data: nil, error: expectedError)
        
        let sut = makeSUT()
        let urlRequest = URLRequest(url: anyURL())
        
        do {
            _ = try await sut.request(urlRequest)
            XCTFail("Expected error, got success")
        } catch {
            XCTAssertEqual((error as? URLError)?.code, expectedError.code)
        }
    }
    
    func test_nonHttpResponse_throwsInvalidResponseError() async throws {
        let nonHttpResponse = URLResponse(
            url: anyURL(),
            mimeType: nil,
            expectedContentLength: 0,
            textEncodingName: nil
        )
        
        URLProtocolStub.stub(response: nonHttpResponse, data: nil, error: nil)
        
        let sut = makeSUT()
        let urlRequest = URLRequest(url: anyURL())
        
        
        do {
            _ = try await sut.request(urlRequest)
            XCTFail("Expected error, got success")
        } catch {
            XCTAssertEqual((error as? HttpClientError), HttpClientError.invalidResponse)
        }
    }
    
    func test_requestSentToCorrectURL() async throws {
        let expectedURL = anyURL()
        let response = HTTPURLResponse(
            url: expectedURL,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )
        let exp = expectation(description: "Wait for request")
        
        URLProtocolStub.stub(response: response, data: Data(), error: nil)
        URLProtocolStub.observeRequests { request in
            XCTAssertEqual(request.url, expectedURL)
            exp.fulfill()
        }
        
        let sut = makeSUT()
        let urlRequest = URLRequest(url: expectedURL)

        _ = try? await sut.request(urlRequest)
        await fulfillment(of: [exp], timeout: 1)
    }
    
    //MARK: Helpers
    
    private func makeSUT() -> URLSessionHttpClient {
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [URLProtocolStub.self]
        let session = URLSession(configuration: config)
        return URLSessionHttpClient(session: session)
    }
    
    private func anyURL() -> URL {
        URL(string: "http://any-url.com")!
    }
}

