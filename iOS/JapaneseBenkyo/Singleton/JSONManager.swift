//
//  JSONReader.swift
//  JapaneseBenkyo
//
//  Created by 김호성 on 2/13/24.
//

import Foundation

class JSONManager {
    
    public static let shared = JSONManager()
    
    private init() {
        
    }
    
    func encode<T: Codable>(data: T) -> String {
        guard let encoded = try? JSONEncoder().encode(data) else {
            return ""
        }
        return String(decoding: encoded, as: UTF8.self)
    }
    
    func decode<T: Codable>(data: Data?, type: T.Type) -> T? {
        guard let data = data, let result = try? JSONDecoder().decode(T.self, from: data) else {
            return nil
        }
        return result
    }
    
    
    func openJSON(path: String) -> Data? {
        guard let path = Bundle.main.path(forResource: path, ofType: "json") else {
            NSLog("Error, JSON file not found.")
            return nil
        }
        let url = URL(fileURLWithPath: path)
        guard let jsonData = try? Data(contentsOf: url) else {
            return nil
        }
        return jsonData
    }
}
