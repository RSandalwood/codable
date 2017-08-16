//
//  OraMessagesResponse.swift
//  codable
//
//  Created by Patrick McCarron on 8/8/17.
//  Copyright © 2017 Patrick McCarron. All rights reserved.
//

import Foundation

struct OraObject: Codable {
    var id: String
    var type: String
    var attributes: [String:String]
    var links: [String:String?]
}

struct OraMessagesResponse: Codable {
    var data : [OraObject]
    var included : [OraObject]
    var links: [String:String?]
}
