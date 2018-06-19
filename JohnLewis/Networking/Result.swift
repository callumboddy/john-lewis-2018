//
//  Result.swift
//  JohnLewis
//
//  Created by Callum Boddy on 19/06/2018.
//  Copyright © 2018 Callum Boddy. All rights reserved.
//

import Foundation

enum Result <T> {
    typealias ValueType = T

    case success(T)
    case failure(Error)

    func value() throws -> T {
        switch self {
        case .success(let value):
            return value
        case .failure(let error):
            throw error
        }
    }

    var isSuccess: Bool {
        switch self {
        case .success: return true
        case .failure: return false
        }
    }

    var isFailure: Bool {
        return !isSuccess
    }

}

extension Result where T == Void {
    static var success: Result<Void> {
        return Result.success(())
    }
}



