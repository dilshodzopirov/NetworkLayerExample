//
//  Created by Dilshod Zopirov on 7/25/25.
//

import Foundation

final class URLSessionHttpClient: HttpClient {
    private let session: URLSession
    
    init(session: URLSession) {
        self.session = session
    }
    
    func request(_ urlRequest: URLRequest) async throws -> ResponseData {
        let (data, response) = try await session.data(for: urlRequest)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw HttpClientError.invalidResponse
        }

        return ResponseData(data: data, response: httpResponse)
    }
}
