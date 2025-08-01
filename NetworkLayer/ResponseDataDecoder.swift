//
//  Created by Dilshod Zopirov on 7/30/25.
//

import Foundation

struct ResponseDataDecoder {
    static func map<T: Decodable>(_ responseData: ResponseData) throws -> T {
        guard (200...299).contains(responseData.response.statusCode) else {
            throw HttpClientError.invalidStatusCode(
                responseData.response.statusCode,
                responseData.data
            )
        }
        return try JSONDecoder().decode(T.self, from: responseData.data)
    }
}
