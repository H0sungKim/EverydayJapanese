//
//  CommonRestAPI.swift
//  JapaneseBenkyo
//
//  Created by 김호성 on 2024.12.14.
//

import Foundation
import Moya

enum CommonRestAPI {
    case getSentence(word: String, cursor_end: String?)
}

extension CommonRestAPI: TargetType {
    var baseURL: URL {
        return URL(string: TatoebaConfiguration.shared.baseURL)!
    }
    
    var path: String {
        switch self {
        case .getSentence(let word):
            return "/unstable/sentences"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getSentence(let word):
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getSentence(let word, let cursor_end):
            var params: [String: Any] = [
                "lang": "jpn",
                "q": word,
                "limit": 1,
                "trans:lang": "kor",
                "sort": "relevance",
                "showtrans": "kor",
            ]
            if let cursor_end = cursor_end {
                params["after"] = cursor_end
            }
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        let headerDic: [String: String] = [
            "Content-type" : "application/json;charset=utf-8",
        ]
        return headerDic
    }
}
