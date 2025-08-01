//
//  Created by Dilshod Zopirov on 7/30/25.
//

import Foundation

final class UserRepository {
    private let httpClient: HttpClient

    init(httpClient: HttpClient) {
        self.httpClient = httpClient
    }

    func fetchUser(id: Int) async throws -> User {
        var request = URLRequest(url: URL(string: "https://api.example.com/users/\(id)")!)
        request.httpMethod = "GET"
        let responseData = try await httpClient.request(request)
        return try UserResponseMapper.map(responseData)
    }
}
