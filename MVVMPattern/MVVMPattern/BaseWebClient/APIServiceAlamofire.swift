//
//  APIService.swift
//  MVVMPattern
//
//  Created by Bharat Jadav on 14/04/22.
//

import Foundation
import UIKit
import Alamofire

typealias ResultCompletion<T> = (_ result:Result<T, Error>) -> Void


struct APIServiceAlamofire<T:Codable> {
    
    var showProgressBlock  : ((Float) -> Void)?
    
    static func responseObject(_ request: BaseAPIRequest, completionHandler: @escaping ResultCompletion<T?>) {
        guard BaseConnectivity.isConnectedToInternet() else {
            let err = NSError(domain: kErrorDomain, code: ServerErrorCode.nointernet.rawValue, userInfo: [NSLocalizedDescriptionKey: "No Internet connection found"])
            return completionHandler(.failure(err as Error))
        }
        AF.request(request.address)
            .validate(statusCode: 200..<510)
            .responseData { response in
                DispatchQueue.main.async {
                    jsonParsing(response, completionResult: completionHandler)
                }
            }
    }
    
    static func uploadMedia(request: MediaAPIRequest, completionHandler: @escaping ResultCompletion<T?>,  progressCompletion: @escaping (_ progressStatus: Double) -> Void?) {
        guard BaseConnectivity.isConnectedToInternet() else {
            let err = NSError(domain: kErrorDomain, code: ServerErrorCode.nointernet.rawValue, userInfo: [NSLocalizedDescriptionKey: "No Internet connection found"])
            return completionHandler(.failure(err as Error))
        }
        
        if request.mediaFileURL == nil, request.mediaData == nil {
            let err = NSError(domain: kErrorDomain, code: ServerErrorCode.none.rawValue, userInfo: [NSLocalizedDescriptionKey: "Please attach media file"])
            return completionHandler(.failure(err as Error))
        }
        
        AF.upload(multipartFormData: { (multiPartFormData) in
            if let url = request.mediaFileURL {
                multiPartFormData.append(url, withName: request.uploadParamName, fileName: request.mediaFileName, mimeType: request.type.mimeType)
            } else if let data = request.mediaData {
                multiPartFormData.append(data, withName: request.uploadParamName, fileName: request.mediaFileName, mimeType: request.type.mimeType)
            }
            
            if let parameters = request.address.parameter {
                for (key, value) in parameters {
                    multiPartFormData.append("\(value)".data(using: .utf8) ?? Data(), withName: key)
                }
            }
        }, with: request.address)
            .validate(statusCode: 200..<300)
            .uploadProgress(closure: { (progress) in
                progressCompletion(progress.fractionCompleted)
            })
            .responseData { response in
                DispatchQueue.main.async {
                    jsonParsing(response, completionResult: completionHandler)
                }
            }
    }
    
    static func jsonParsing<T:Codable>(_ resData:AFDataResponse<Data>, completionResult: @escaping ResultCompletion<T?>){
        switch resData.result {
        case .success(let value):
            let jsonDecoder = JSONDecoder()
            do {
                let empData = try jsonDecoder.decode(GeneralResponse<T>.self, from: value)
                guard let statusCode = resData.response?.statusCode,
                      statusCode == ServerErrorCode.success.rawValue else {
                          let err = NSError(domain: kErrorDomain, code: resData.response?.statusCode ?? 0, userInfo: [NSLocalizedDescriptionKey: empData.message ?? ""])
                          return completionResult(.failure(err as Error))
                      }
                AppUtility.shared.printToConsole("Response Data : \(empData.data as Any)")
                return completionResult(.success(empData.data != nil ? empData.data : empData as? T))
            } catch let error {
                return completionResult(.failure(error))
            }
        case .failure(let afError):
            print(afError.errorDescription ?? "")
            let err = NSError(domain: kErrorDomain, code: afError.responseCode ?? 0, userInfo: [NSLocalizedDescriptionKey: afError.errorDescription ?? ""])
            return completionResult(.failure(err as Error))
        }
    }
    
}


