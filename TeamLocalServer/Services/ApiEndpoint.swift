//
//  ApiEndpoint.swift
//  TeamLocalServer
//
//  Created by Snow Lukin on 01.12.2023.
//

import Foundation

protocol ApiEndpoint {
    var baseUrlString: String { get }
    var apiPath: String { get }
    var apiVersion: String? { get }
    var separatorPath: String? { get }
    var path: String { get }
    var headers: [String: String]? { get }
    var queryItems: [URLQueryItem]? { get }
    var params: [String: Any]? { get }
    var method: HTTPMethod { get }
    var body: Data? { get }
}

extension ApiEndpoint {
    var makeRequest: URLRequest {
        var urlComponents = URLComponents(string: baseUrlString)
        var longPath = "/"
        longPath.append(apiPath)
        if let apiVersion {
            longPath.append("/")
            longPath.append(apiVersion)
        }
        if let separatorPath {
            longPath.append("/")
            longPath.append(separatorPath)
        }
        longPath.append("/")
        longPath.append(path)
        
        if let queryItems {
            urlComponents?.queryItems = []
            queryItems.forEach {
                urlComponents?.queryItems?.append($0)
            }
        }
        
        guard let url = urlComponents?.url else {
            let url = URL(string: baseUrlString)!
            return URLRequest(url: url)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        if let headers {
            for header in headers {
                request.addValue(header.value, forHTTPHeaderField: header.key)
            }
        }
        
        if let params {
            let jsonData = try? JSONSerialization.data(withJSONObject: params)
            request.httpBody = jsonData
        }
        
        if let body {
            request.httpBody = body
        }
        
        return request
    }
}
