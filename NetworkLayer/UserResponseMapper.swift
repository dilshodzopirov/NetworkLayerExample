//
//  Created by Dilshod Zopirov on 7/30/25.
//

import Foundation

struct UserResponseMapper {
    static func map(_ responseData: ResponseData) throws -> User {
        let dto: UserDTO = try ResponseDataDecoder.map(responseData)
        guard let id = dto.user_id, let name = dto.full_name else {
            throw HttpClientError.invalidResponse
        }
        
        return User(id: id, name: name)
    }
    
    private struct UserDTO: Decodable {
        let user_id: Int?
        let full_name: String?
    }
}
