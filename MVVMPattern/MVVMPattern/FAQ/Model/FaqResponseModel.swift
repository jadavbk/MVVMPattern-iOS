//
//  FaqResponseModel.swift
//  MVVMPattern
//
//  Created by Bharat Jadav on 19/04/22.
//

import Foundation

struct FaqResponseModel: Codable {
    let title : String?
    let description : String?
    
    enum CodingKeys: String, CodingKey {
        case title            = "title"
        case description      = "description"
    }
}


struct UserResponseModel: Codable {
    let title : String?
    let description : String?
    
    enum CodingKeys: String, CodingKey {
        case title            = "name"
        case description      = "email"
    }
}

struct ContactRequestModel: Codable {
    var emailid   : String? = ""
    var message   : String? = ""
    
    enum CodingKeys: String, CodingKey {
        case emailid      = "email_id"
        case message      = "message"
    }
    
    init() {
    }
}

struct updateProfileRequestModel: Codable {
    var file : Data? = nil
    var fileURL : URL? = nil
    var fileName : String = ""
    var bio : String = ""
    
    enum CodingKeys: String, CodingKey {
        case file = "file1"
        case fileURL = "file"
        case fileName = "fileName"
        case bio = "bio"
    }
    
    init() {
    }
}


