//
//  APIService.swift
//  MVVMPattern
//
//  Created by Bharat Jadav on 14/04/22.
//

import Foundation
import UIKit

struct APIService<T:Codable> {
    static func responseObject(_ request: BaseAPIRequest, completionHandler: @escaping ResultCompletion<T?>) {
        guard BaseConnectivity.isConnectedToInternet() else {
            let err = NSError(domain: kErrorDomain, code: ServerErrorCode.nointernet.rawValue, userInfo: [NSLocalizedDescriptionKey: "No Internet connection found"])
            return completionHandler(.failure(err as Error))
        }
        
        let urlRequest: URLRequest
        let session = URLSession.shared
        do {
            urlRequest = try request.address.asURLRequest()
            session.dataTask(with: urlRequest) { (data, response, error) in
                //AppUtility.shared.showGlobalLoader(animating: false)
                if let error = error {
                    return  completionHandler(.failure(error))
                }
                
                guard let data = data else {return}
                let jsonDecoder = JSONDecoder()
                do {
                    let json = try? JSONSerialization.jsonObject(with: data, options: [])
                    AppUtility.shared.printToConsole(json as Any)
                    let empData = try jsonDecoder.decode(GeneralResponse<T>.self, from: data)
                    if empData.data == nil {
                        if let statusCode = (response as? HTTPURLResponse)?.statusCode,
                           statusCode != ServerErrorCode.success.rawValue {
                            let err = NSError(domain: kErrorDomain, code: statusCode, userInfo: [NSLocalizedDescriptionKey: empData.message ?? ""])
                            
                            return completionHandler(.failure(err as Error))
                        }
                        return completionHandler(.success(empData as? T))
                    }
                    else {
                        return completionHandler(.success(empData.data))
                    }
                } catch let error {
                    return completionHandler(.failure(error))
                }
            }.resume()
            
        } catch {
            print(error)
        }
    }
    
    static func uploadMedia(request: MediaAPIRequest, completionHandler: @escaping ResultCompletion<T?>) {
        guard BaseConnectivity.isConnectedToInternet() else {
            let err = NSError(domain: kErrorDomain, code: ServerErrorCode.nointernet.rawValue, userInfo: [NSLocalizedDescriptionKey: "No Internet connection found"])
            return completionHandler(.failure(err as Error))
        }
        
        if request.mediaFileURL == nil, request.mediaData == nil {
            let err = NSError(domain: kErrorDomain, code: ServerErrorCode.none.rawValue, userInfo: [NSLocalizedDescriptionKey: "Please attach media file"])
            return completionHandler(.failure(err as Error))
        }
        
        let session = URLSession.shared
        guard let url = URL(string: "\(currentEnvironment.baseURL)\(request.address.path)") else { return }
        let multiPartFormData = MultipartFormDataRequest(url: url)
        
        if let mediaData = request.mediaData {
            multiPartFormData.addDataField(named: request.uploadParamName, data: mediaData, mimeType: request.type.mimeType)
        }
//        else if let data = request.mediaData {
//            multiPartFormData.append(data, withName: request.uploadParamName, fileName: request.mediaFileName, mimeType: request.mediaType.mimeType)
//        }
        
        let observation: NSKeyValueObservation?
        
        let task = session.dataTask(with: multiPartFormData, completionHandler: {(data, response, error) in
            if let error = error {
                return  completionHandler(.failure(error))
            }
            
            guard let data = data else {return}
            let jsonDecoder = JSONDecoder()
            do {
                let json = try? JSONSerialization.jsonObject(with: data, options: [])
                AppUtility.shared.printToConsole(json as Any)
                let empData = try jsonDecoder.decode(GeneralResponse<T>.self, from: data)
                if empData.data == nil {
                    if let statusCode = (response as? HTTPURLResponse)?.statusCode,
                       statusCode != ServerErrorCode.success.rawValue {
                        let err = NSError(domain: kErrorDomain, code: statusCode, userInfo: [NSLocalizedDescriptionKey: empData.message ?? ""])
                        
                        return completionHandler(.failure(err as Error))
                    }
                    return completionHandler(.success(empData as? T))
                }
                else {
                    return completionHandler(.success(empData.data))
                }
            } catch let error {
                return completionHandler(.failure(error))
            }
        })
        
        // Don't forget to invalidate the observation when you don't need it anymore.
        observation = task.progress.observe(\.fractionCompleted) { progress, _ in
            print("==> Progress: \(progress.fractionCompleted)")
        }
        observation?.invalidate()
        task.resume()
    }
}
