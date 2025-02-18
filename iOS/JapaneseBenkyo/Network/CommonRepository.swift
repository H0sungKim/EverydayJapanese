//
//  CommonRepository.swift
//  JapaneseBenkyo
//
//  Created by 김호성 on 2024.12.14.
//

import Foundation
import Moya
import CombineMoya
import Combine

class CommonRepository {
    static let shared = CommonRepository()
    private init() {
        
    }
    
    private let provider = MoyaProvider<CommonRestAPI>(plugins: [NetworkLoggerPlugin()])
    
    func getSentence(word: String, cursor_end: String? = nil) -> AnyPublisher<TatoebaModel, MoyaError> {
        return provider.requestPublisher(CommonRestAPI.getSentence(word: word, cursor_end: cursor_end))
            .map(TatoebaEntity.self)
            .subscribe(on: DispatchQueue.global())
            .receive(on: DispatchQueue.main)
            .map({ tatoebaEntity in
                return TatoebaModel(tatoebaEntity: tatoebaEntity)
            })
            .eraseToAnyPublisher()
    }
}
