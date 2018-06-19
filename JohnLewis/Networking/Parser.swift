//
//  Parser.swift
//  JohnLewis
//
//  Created by Callum Boddy on 19/06/2018.
//  Copyright © 2018 Callum Boddy. All rights reserved.
//

import Foundation

struct Parser {
    static func from<T: Decodable>(data: Data, key: String = "") -> [T] {

        // searlize json
        guard let json = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableLeaves) as? [String: Any] else {
            return []
        }

        // extract diction from provied key
        guard let data = try? JSONSerialization.data(withJSONObject: json?[key], options: JSONSerialization.WritingOptions.prettyPrinted) else {
            return []
        }

        // create and parse Codable enabled generic model object & return
        let objects = try? JSONDecoder().decode([T].self, from: data)

        return objects ?? []
    }
}
