//
//  Created by Dilshod Zopirov on 8/2/25.
//

import Foundation

struct UserRepositoryFactory {
    static func makeUserRepositoryWithUrlSessionHttpClient() -> UserRepository {
        let httpClient = URLSessionHttpClient(session: URLSession.shared)
        return UserRepository(httpClient: httpClient)
    }
    
    static func makeUserRepositoryWithAlamofireHttpClient() -> UserRepository {
        let httpClient = AlamofireHttpClient()
        return UserRepository(httpClient: httpClient)
    }
}
