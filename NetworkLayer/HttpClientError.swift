//
//  Created by Dilshod Zopirov on 7/30/25.
//

import Foundation

enum HttpClientError: Error, Equatable {
    case invalidResponse
    case invalidStatusCode(Int, Data?)
}
