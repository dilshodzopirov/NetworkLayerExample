//
//  Created by Dilshod Zopirov on 8/2/25.
//

import Foundation
internal import Alamofire

final class AlamofireHttpClient: HttpClient {
    func request(_ urlRequest: URLRequest) async throws -> ResponseData {
        let dataTask = AF.request(urlRequest).serializingData()
        let result = await dataTask.response
        
        guard let data = result.data, let httpResponse = result.response else {
            throw URLError(.badServerResponse)
        }
        
        return (data: data, response: httpResponse)
    }
}
