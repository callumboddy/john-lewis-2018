//
//  SearchProduct.swift
//  JohnLewis
//
//  Created by Callum Boddy on 19/06/2018.
//  Copyright © 2018 Callum Boddy. All rights reserved.
//

import Foundation


/// a search product is a product returned from the Search Api, it differs from a product and should only be used to display lighter infomation in search/browse journeys.
struct SearchProduct: Codable {
    private let image: String

    let identifier: String
    let title: String
    let price: Price

    var imageURL: URL? {
        return URL(string: "https:\(image)")
    }

    struct Price: Codable {
        let now: String
    }

    enum CodingKeys: String, CodingKey {
        case identifier = "productId"
        case title, image, price
    }
}
