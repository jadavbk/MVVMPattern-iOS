//
//  APIRequest.swift
//  MVVMPattern
//
//  Created by Bharat Jadav on 18/04/22.
//

import Foundation
import Alamofire

var kInternetConnectionMessage = "Please check your internet connection"
var kTryAgainLaterMessage = "Please try again later"
var kErrorDomain = "Error"
var kDefaultErrorCode = 1234

public let IS_GO_LIVE = true ///need to add on constant files
public let APIVersion = "v1"

enum Session: Int {
    case active = 1
    case expire = 2
}

public enum BaseEnvironmentType {
    case stagging
    case production
    case clientReview
    var baseURL: String {
        switch self {
            case .stagging:
                return "https://stgapi.com/api/" ///staging URL
            case .production:
                return "https://stgapi.com/api/" /// Production URL
            case .clientReview:
                return "https://stgapi.com/api/" /// Client Review
        }
    }
}
public let currentEnvironment:BaseEnvironmentType = IS_GO_LIVE ? .production : .stagging


enum HTTPMethod : String {
    case get     = "GET"
    case post    = "POST"
    case put     = "PUT"
    case delete  = "DELETE"
}

enum ServerErrorCode: Int {
    case success = 200
    case userNotFound = 404
    case none = 0
    case userInActive = 400
    case sessionExpire = 401
    case nointernet = -1009
}

struct BaseAPIRequest {
    let address: BaseAPIAddress
    init(_ address: BaseAPIAddress) {
        self.address = address
    }
}

enum BaseAPIAddress: URLRequestConvertible {
    case login(parameters: Parameters)
    case getUserProfile
    case faqs
    case contactus(parameters: Parameters)
    case updateProfile(parameters: Parameters)
    
    var method: HTTPMethod {
        switch self {
        case .login, .contactus, .updateProfile:
                return .post
            case .getUserProfile, .faqs:
                return .get
//            case :
//                return .put
//            case :
//                return .delete
        }
    }
    
    var path: String {
        switch self {
            case .login:
                return "users/login"
            case .getUserProfile:
                return "users/profile"
            case .faqs:
                return "master/faqs"
            case .contactus:
                return "master/contact-us"
            case .updateProfile:
                return "users/update-user-data"
        }
    }
    
    var parameter: Parameters? {
        switch self {
        case .login(let parameters), .contactus(let parameters), .updateProfile(let parameters):
                return parameters
            case .getUserProfile, .faqs:
                return nil
        }
    }
    
    // MARK: URLRequestConvertible
    func asURLRequest() throws -> URLRequest {
        let url = try currentEnvironment.baseURL.asURL()
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
//        if let authToken = UserModel.loggedInUserToken(), authToken.isValid {
//            urlRequest.headers = ["authorization": "\(authToken)"] ///authToken
//        }
        urlRequest.headers = ["authorization": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MywiaWF0IjoxNjUwNTE5NzY0fQ.I8rWm3HdI2oPRA_EEdNLFtnijTXneJRpAivscvXvmBU"] ///authToken
        print(urlRequest.headers)
        switch self {
            case .login(let parameters), .contactus(let parameters):
                urlRequest = try JSONEncoding.default.encode(urlRequest, with: parameters)
        default:
            break
        }
        print(urlRequest.description)
        //print("parameter:\(String(describing: parameter))")
        return urlRequest
    }
}

enum MediaType : Int {
    case text   = 0
    case image  = 1
    case video  = 2
    case audio  = 3
    
    var mimeType: String {
        switch self {
        case .image:
            return "image/jpeg"
        case .video:
            return "video/mp4"
        default:
            return ""
        }
    }
}

struct MediaAPIRequest {
    let address: BaseAPIAddress
    var `type`: MediaType
    var mediaData: Data?
    var mediaFileURL: URL?
    var mediaFileName: String
    var uploadParamName: String
    
    init(_ address: BaseAPIAddress,
         mediaType: MediaType,
         mediaData: Data? = nil,
         mediaFileURL: URL? = nil,
         mediaFileName: String = "",
         uploadParamName: String) {
        self.address = address
        self.type = mediaType
        self.mediaData = mediaData
        self.mediaFileURL = mediaFileURL
        self.mediaFileName = mediaFileName.count > 0 ? mediaFileName : (mediaType == .image ? "\(Date()).jpg" : "\(Date()).mp4")
        self.uploadParamName = uploadParamName
    }
}
