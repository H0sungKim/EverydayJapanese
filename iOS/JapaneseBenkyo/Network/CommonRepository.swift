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
    
    func getSentence(word: String, trans: TransEnum, cursor_end: String? = nil) -> AnyPublisher<TatoebaModel, TatoebaError> {
        return provider.requestPublisher(CommonRestAPI.getSentence(word: word, trans: trans, cursor_end: cursor_end))
            .map(TatoebaEntity.self)
            .tryMap({ tatoebaEntity in
                guard let isEmpty = tatoebaEntity.data?.isEmpty, !isEmpty else {
                    throw TatoebaError.resultNil
                }
                return tatoebaEntity
            })
            .mapError({ error in
                if let error = error as? MoyaError {
                    return TatoebaError.moyaError(error: error)
                }
                return error as! TatoebaError
            })
            .subscribe(on: DispatchQueue.global())
            .receive(on: DispatchQueue.main)
            .map({ tatoebaEntity in
                return TatoebaModel(tatoebaEntity: tatoebaEntity, trans: trans)
            })
            .eraseToAnyPublisher()
    }
}
