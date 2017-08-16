//
//  OraAPIManager.swift
//  codable
//
//  Created by Patrick McCarron on 8/6/17.
//  Copyright © 2017 Patrick McCarron. All rights reserved.
//

import Foundation

class OraAPIManager: APIManager {
    
    override init() {
        super.init()
        baseURL = URL(string: "https://private-anon-b3ab4bad0a-orachallenge.apiary-mock.com/api/v1/")
    }
    
    func isAuthorized() -> Bool {
        if let token = token, token.count > 0 {
            return true
        }
        return false
    }
    
    func clearAuth() {
        token = nil
    }
    
    func requestAuth(completion: (() -> ())? = nil) {
        post("sessions", success: { [weak self] data, response in
            if let token = response?.allHeaderFields["Authorization"] as? String {
                self?.token = token
                completion?()
            } else {
                print("no auth header found")
                completion?()
            }
        }, failure: { error in
            print("Auth API failure \(error)")
        })
    }
    
    func requestMessages(page: Int = 0, completion: ((OraMessagesResponse) -> ())? = nil) {
        get("messages", success:  { data, response in
            let decoder = JSONDecoder()
            if let data = data {
                do {
                    let decoded = try decoder.decode(OraMessagesResponse.self, from: data)
                    completion?(decoded)
                } catch {
                    print("Decoding error: \(error)")
                }
            }
        }, failure: { error in
            print("Message API failure \(error)")
        })
    }
}
