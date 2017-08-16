//
//  DictionaryExtension.swift
//  codable
//
//  Created by Patrick McCarron on 8/6/17.
//  Copyright © 2017 Patrick McCarron. All rights reserved.
//

import Foundation

extension Dictionary {
    func json() -> Data? {
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            encoder.dateEncodingStrategy = .iso8601
            let params = try encoder.encode(self)
            print(String(data: params, encoding: .utf8)!)
            return params
        } catch {
            print(error)
        }
        return nil
    }
}
