//
//  Created by Dilshod Zopirov on 7/30/25.
//

import Foundation

final class URLProtocolStub: URLProtocol {
    private static var stub: Stub?
    private static var requestObserver: ((URLRequest) -> Void)?
   
    private struct Stub {
        var response: URLResponse?
        var data: Data?
        var error: Error?
    }
    
    static func stub(response: URLResponse?, data: Data?, error: Error?) {
        stub = Stub(response: response, data: data, error: error)
    }
    
    static func observeRequests(observer: @escaping (URLRequest) -> Void) {
        Self.requestObserver = observer
    }
    
    static func startInterceptingRequests() {
        URLProtocol.registerClass(URLProtocolStub.self)
    }
    
    static func stopInterceptingRequests() {
        stub = nil
        requestObserver = nil
        URLProtocol.unregisterClass(URLProtocolStub.self)
    }

    override class func canInit(with request: URLRequest) -> Bool {
        true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        request
    }
    
    override func startLoading() {
        if let observer = URLProtocolStub.requestObserver {
            observer(request)
        }
        
        if let error = Self.stub?.error {
            client?.urlProtocol(self, didFailWithError: error)
        } else {
            if let data = Self.stub?.data {
                client?.urlProtocol(self, didLoad: data)
            }
            
            if let response = Self.stub?.response {
                client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            }
            
            client?.urlProtocolDidFinishLoading(self)
        }
    }
    
    override func stopLoading() {}
}
