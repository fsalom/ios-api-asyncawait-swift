//
//  TokenDTO.swift
//  Template
//
//  Created by Joel Sifres Clemente on 28/9/21.
//  Copyright © 2021 Rudo. All rights reserved.
//

import Foundation

struct TokenDTO: Codable {
    let accessToken: String
    let refreshToken: String
    let expiresIn: Int

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
        case expiresIn = "expires_in"
    }
}
