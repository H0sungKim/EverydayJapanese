//
//  TatoebaError.swift
//  JapaneseBenkyo
//
//  Created by 김호성 on 2025.02.20.
//

import Foundation
import Moya

public enum TatoebaError: Error {
    case moyaError(error: MoyaError)
    case resultNil
    
    var description: String {
        switch self {
        case .moyaError(let error):
            return "Moya Error - \(error)\n\(error.response)\n\(error.localizedDescription)"
        case .resultNil:
            return "Result Nil Error"
        }
    }
}
