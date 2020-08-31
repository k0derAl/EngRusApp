//
//  TransalateService.swift
//  TranslateTestApp


import Foundation
import Moya
import RxSwift
import RxCocoa

class TranslateService {
    
    var provider = MoyaProvider<TranslateAPI>()
    
    func getTranslateList(query: String, page: Int = 1, pageSize: Int = 20) -> Observable<[WordCombination]> {
        return provider.rx.request(.getTranslate(query: query, page: page, pageSize: pageSize)).map([WordCombination].self).asObservable()
    }
}
