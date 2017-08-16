//
//  APIManager.swift
//  codable
//
//  Created by Patrick McCarron on 8/6/17.
//  Copyright © 2017 Patrick McCarron. All rights reserved.
//

import Foundation

enum APIError: Error {
    case noResponse
    case unauthorized
    case withMessage(String)
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
}

struct APIResponseError : Codable {
    var message: String
}

class APIManager {
    
    var baseURL = URL(string: "http://www.google.com")
    var token: String?

    @discardableResult func post(_ URLString: String, parameters: [String:Any]? = nil, success: ((Data?, HTTPURLResponse?) -> Void)? = nil, failure: ((Error) -> Void)? = nil) -> URLSessionDataTask? {
        return makeAPICall(.post, URLString: URLString, parameters: parameters, success: success, failure: failure)
    }

    @discardableResult func get(_ URLString: String, parameters: [String:Any]? = nil, success: ((Data?, HTTPURLResponse?) -> Void)? = nil, failure: ((Error) -> Void)? = nil) -> URLSessionDataTask? {
        return makeAPICall(.get, URLString: URLString, parameters: parameters, success: success, failure: failure)
    }

    @discardableResult func put(_ URLString: String, parameters: [String:Any]? = nil, success: ((Data?, HTTPURLResponse?) -> Void)? = nil, failure: ((Error) -> Void)? = nil) -> URLSessionDataTask? {
        return makeAPICall(.put, URLString: URLString, parameters: parameters, success: success, failure: failure)
    }

    @discardableResult func makeAPICall(_ method: HTTPMethod, URLString: String, parameters: [String:Any]?, success: ((Data?, HTTPURLResponse?) -> Void)?, failure: ((Error) -> Void)?) -> URLSessionDataTask? {
        guard let url = URL(string: URLString, relativeTo:baseURL) else {
            print("Error: cannot create URL")
            return nil
        }
        var urlRequest = URLRequest(url: url)
        print("URL = \(String(describing: urlRequest.url))")
        urlRequest.httpMethod = method.rawValue
        urlRequest.setValue("application/vnd.api+json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("application/vnd.api+json", forHTTPHeaderField: "Accept")
        
        if let token = token {
            urlRequest.setValue(token, forHTTPHeaderField: "Authorization")
        }
        print("Headers: \(String(describing: urlRequest.allHTTPHeaderFields))")
        
        if let parameters = parameters, let jsonData = parameters.json()  {
            print("Body: \(String(data: jsonData, encoding: .utf8)!)")
            urlRequest.httpBody = jsonData
        }
        
        // set up the session
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        // make the request
        let task = session.dataTask(with: urlRequest) { data, response, error in
            guard let data = data else {
                print("no response")
                failure?(APIError.noResponse)
                return
            }
            print("Response: \(String(data: data, encoding: .utf8)!)")
            if let decoded = try? JSONDecoder().decode(APIResponseError.self, from: data) {
                if decoded.message.count > 0 {
                    let error = APIError.withMessage(decoded.message)
                    failure?(error)
                    return
                }
            }
            guard let response = response as? HTTPURLResponse else { return }
            success?(data, response)
        }
        task.resume()
        return task
    }
    
}
