//
//  TranslateAPI.swift
//  TranslateTestApp


import Foundation
import RxSwift
import Moya


enum TranslateAPI {
    case getTranslate(query: String, page: Int, pageSize: Int)

    static let apiURL = "https://dictionary.skyeng.ru/api/public/v1/"
}

extension TranslateAPI: TargetType {
    var baseURL: URL {
        return URL(string: TranslateAPI.apiURL)!
    }
    
    var path: String {
        switch self {
        case .getTranslate:
            return "words/search"
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .getTranslate(let query, let page, let pageSize):
            return .requestParameters(parameters: ["search": query, "page": page, "pageSize": pageSize], encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return nil//["Accept": "application/json"]
    }
}
