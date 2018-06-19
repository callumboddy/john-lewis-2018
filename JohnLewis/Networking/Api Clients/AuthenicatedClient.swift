//
//  AuthenicatedClient.swift
//  JohnLewis
//
//  Created by Callum Boddy on 19/06/2018.
//  Copyright © 2018 Callum Boddy. All rights reserved.
//

import Foundation

protocol AuthenicatedClient {
    func apiKey() -> String
}

extension AuthenicatedClient {
    func apiKey() -> String {

        // TODO: update to return Configuration.current once we have set up differenct environments
        return "Wu1Xqn3vNrd1p7hqkvB6hEu0G9OrsYGb"
    }
}
