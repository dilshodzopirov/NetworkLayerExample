//
//  Created by Dilshod Zopirov on 7/30/25.
//

import Foundation

typealias ResponseData = (data: Data, response: HTTPURLResponse)

protocol HttpClient {
    func request(_ urlRequest: URLRequest) async throws -> ResponseData
}
