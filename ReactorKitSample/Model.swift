//
//  Model.swift
//  ReactorKitSample
//
//  Created by Fumiya Tanaka on 2020/06/13.
//  Copyright © 2020 Fumiya Tanaka. All rights reserved.
//

import Foundation

enum Model {
    struct Request: Encodable {
        let title: String
        let content: String?
    }
    
    struct Response: Decodable {
        let id: Int
        var title: String
        var content: String?
        var due: String?
        
        enum CodingKeys: String, CodingKey {
            case id = "ID"
            case title = "Title"
            case content = "Content"
            case due = "Due"
        }
    }
}
