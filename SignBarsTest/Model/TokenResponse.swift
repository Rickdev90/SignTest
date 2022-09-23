//
//  TokenResponse.swift
//  SignBarsTest
//
//  Created by Rick on 22/09/22.
//

import Foundation

public struct TokenResponse: Codable {
    let success: Bool?
    let token: String?
}

public struct UserPass: Codable {
    var email: String?
    var pass: String?
}
