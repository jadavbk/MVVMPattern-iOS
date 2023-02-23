//
//  APIResponseModel.swift
//  MVVMPattern
//
//  Created by Bharat Jadav on 19/04/22.
//

import Foundation

class GeneralResponse<T : Codable> : Codable {
    //    var code: Int = 0
    var message : String?
    var data    : T?
    var token   : String?
    var status  : Int?
    
    enum CodingKeys: String, CodingKey {
        case message    = "message"
        case data       = "data"
        case token      = "token"
        case status     = "status"
    }
    
    required init(from decoder: Decoder) throws {
        do {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            if let msgProperty = try? container.decode(Int.self, forKey: .status) {
                status = msgProperty
            }
            if let msgProperty = try? container.decode(String.self, forKey: .message) {
                message = msgProperty
            }
            if let tokenProperty = try? container.decode(String.self, forKey: .token) {
                token = tokenProperty
            }
            if let objProperty = try? container.decode(T.self, forKey: .data) {
                data = objProperty
            }
        }
    }
}

class GeneralWitoutData : Codable {
    //    var code: Int = 0
    var message : String?
    var token   : String?
    var status  : Int?
    
    enum CodingKeys: String, CodingKey {
        case message    = "message"
        case token      = "token"
        case status     = "status"
    }
    
    required init(from decoder: Decoder) throws {
        do {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            if let msgProperty = try? container.decode(Int.self, forKey: .status) {
                status = msgProperty
            }
            if let msgProperty = try? container.decode(String.self, forKey: .message) {
                message = msgProperty
            }
            if let tokenProperty = try? container.decode(String.self, forKey: .token) {
                token = tokenProperty
            }
        }
    }
}

class GeneralData : Decodable {
    //    var code: Int = 0
    var message : String?
    var token   : String?
    var status  : Int?
    
    enum CodingKeys: String, CodingKey {
        case message    = "message"
        case token      = "token"
        case status     = "status"
    }
    
    required init(from decoder: Decoder) throws {
        do {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            if let msgProperty = try? container.decode(Int.self, forKey: .status) {
                status = msgProperty
            }
            if let msgProperty = try? container.decode(String.self, forKey: .message) {
                message = msgProperty
            }
            if let tokenProperty = try? container.decode(String.self, forKey: .token) {
                token = tokenProperty
            }
        }
    }
}

struct ErrorModel: Codable {
    var code: Int?
    var codeMessage: String?
    var message: String?
    
    enum CodingKeys: String, CodingKey {
        case code           = "code"
        case codeMessage    = "codeMessage"
        case message        = "message"
    }
}
