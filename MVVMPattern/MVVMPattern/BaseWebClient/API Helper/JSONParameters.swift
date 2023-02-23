//
//  JSONParameters.swift
//  MVVMPattern
//
//  Created by Bharat Jadav on 18/04/22.
//

import Foundation

// MARK: -

/// Uses `JSONSerialization` to create a JSON representation of the parameters object, which is set as the body of the
/// request. The `Content-Type` HTTP header field of an encoded request is set to `application/json`.
//public struct JSONEncoding: ParameterEncoding {
//    // MARK: Properties
//    
//    /// Returns a `JSONEncoding` instance with default writing options.
//    public static var `default`: JSONEncoding { return JSONEncoding() }
//    
//    /// Returns a `JSONEncoding` instance with `.prettyPrinted` writing options.
//    public static var prettyPrinted: JSONEncoding { return JSONEncoding(options: .prettyPrinted) }
//    
//    /// The options for writing the parameters as JSON data.
//    public let options: JSONSerialization.WritingOptions
//    
//    // MARK: Initialization
//    
//    /// Creates an instance using the specified `WritingOptions`.
//    ///
//    /// - Parameter options: `JSONSerialization.WritingOptions` to use.
//    public init(options: JSONSerialization.WritingOptions = []) {
//        self.options = options
//    }
//    
//    // MARK: Encoding
//    
//    public func encode(_ urlRequest: URLRequest, with parameters: Parameters?) throws -> URLRequest {
//        var urlRequest = urlRequest
//        
//        guard let parameters = parameters else { return urlRequest }
//        
//        do {
//            let data = try JSONSerialization.data(withJSONObject: parameters, options: options)
//            
//            if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
//                urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
//            }
//            
//            urlRequest.httpBody = data
//        } catch let err {
//            throw err
//        }
//        
//        return urlRequest
//    }
//    
//    /// Encodes any JSON compatible object into a `URLRequest`.
//    ///
//    /// - Parameters:
//    ///   - urlRequest: `URLRequestConvertible` value into which the object will be encoded.
//    ///   - jsonObject: `Any` value (must be JSON compatible` to be encoded into the `URLRequest`. `nil` by default.
//    ///
//    /// - Returns:      The encoded `URLRequest`.
//    /// - Throws:       Any `Error` produced during encoding.
//    public func encode(_ urlRequest: URLRequestConvertible, withJSONObject jsonObject: Any? = nil) throws -> URLRequest? {
//        var urlRequest = try urlRequest.asURLRequest()
//        
//        guard let jsonObject = jsonObject else { return urlRequest }
//        
//        do {
//            let data = try JSONSerialization.data(withJSONObject: jsonObject, options: options)
//            
//            if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
//                urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
//            }
//            
//            urlRequest.httpBody = data
//        } catch let err {
//            throw err
//        }
//        
//        return urlRequest
//    }
//}
//
//// MARK: -
//
///// Types adopting the `URLRequestConvertible` protocol can be used to safely construct `URLRequest`s.
//public protocol URLRequestConvertible {
//    /// Returns a `URLRequest` or throws if an `Error` was encoutered.
//    ///
//    /// - Returns: A `URLRequest`.
//    /// - Throws:  Any error thrown while constructing the `URLRequest`.
//    func asURLRequest() throws -> URLRequest
//}
//
///// A type used to define how a set of parameters are applied to a `URLRequest`.
//public protocol ParameterEncoding {
//    /// Creates a `URLRequest` by encoding parameters and applying them on the passed request.
//    ///
//    /// - Parameters:
//    ///   - urlRequest: `URLRequestConvertible` value onto which parameters will be encoded.
//    ///   - parameters: `Parameters` to encode onto the request.
//    ///
//    /// - Returns:      The encoded `URLRequest`.
//    /// - Throws:       Any `Error` produced during parameter encoding.
//    func encode(_ urlRequest: URLRequest, with parameters: Parameters?) throws -> URLRequest
//}
//
///// `URLRequests`.
//public protocol URLConvertible {
//    /// Returns a `URL` from the conforming instance or throws.
//    ///
//    /// - Returns: The `URL` created from the instance.
//    /// - Throws:  Any error thrown while creating the `URL`.
//    func asURL() throws -> URL
//}
//
//public enum AFError: Error {
//    case invalidURL(url: URLConvertible)
//}
//
//extension String: URLConvertible {
//    /// Returns a `URL` if `self` can be used to initialize a `URL` instance, otherwise throws.
//    ///
//    /// - Returns: The `URL` initialized with `self`.
//    /// - Throws:  An `AFError.invalidURL` instance.
//    public func asURL() throws -> URL {
//        guard let url = URL(string: self) else { throw AFError.invalidURL(url: self) }
//        
//        return url
//    }
//}

struct JSON {
    static let encoder = JSONEncoder()
}

extension Encodable {
    var convertToString: String? {
        let jsonEncoder = JSONEncoder()
        jsonEncoder.outputFormatting = .prettyPrinted
        do {
            let jsonData = try jsonEncoder.encode(self)
            return String(data: jsonData, encoding: .utf8)
        } catch {
            return nil
        }
    }
    
    subscript(key: String) -> Any? {
        return dictionary[key]
    }
    var dictionary: [String: Any] {
        return (try? JSONSerialization.jsonObject(with: JSON.encoder.encode(self))) as? [String: Any] ?? [:]
    }
}
