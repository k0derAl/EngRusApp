//
//  TranslateWordListViewModel.swift
//  TranslateTestApp


import Foundation
import RxSwift
import RxCocoa

protocol TranslateWordListViewModelProtocol {
    
    var words: BehaviorRelay<[WordCombination]> {  get set }
    var isLoading: BehaviorRelay<Bool> {  get set }
    var isLoadingMore: Bool {  get set }
    var isFinished: Bool {  get set }
    var error: PublishRelay<String> {  get set }
    
    func searchWords(query: String)
    func loadMoreWords()
    func clearAllModel()
}

final class TranslateWordListViewModel: TranslateWordListViewModelProtocol {
    
    var words: BehaviorRelay<[WordCombination]>
    var isLoading: BehaviorRelay<Bool>
    var isLoadingMore: Bool
    var isFinished: Bool
    var error: PublishRelay<String>
    
    private let translateService = TranslateService()
    private var disposeBag = DisposeBag()
    
    private var loadedPages: Int?
    private var pageSize: Int?
    private var currentQuery: String?
    
    init(error:Bool = false) {
        self.words = BehaviorRelay<[WordCombination]>(value: [])
        self.isLoading = BehaviorRelay<Bool>(value: false)
        self.isLoadingMore = false
        self.isFinished = false
        self.error = PublishRelay<String>()
        if error {
            fatalError("Fattal Error For Test")
        }
    }
    
    // MARK: Loading words by new query
    func searchWords(query: String) {
        self.clearAllModel()
        self.isLoading.accept(true)
        translateService.getTranslateList(query: query).subscribe(onNext: { [weak self] (response) in
            guard let `self` = self else { return }
            if response.count == 1, response.first!.id == 0 {
                self.isFinished = true
            } else {
                self.currentQuery = query
                self.loadedPages = 1
                self.words.accept(response)
            }
            self.isLoading.accept(false)
        }, onError: { [weak self] (error) in
            guard let `self` = self else { return }
            self.error.accept(error.localizedDescription)
            self.isLoading.accept(false)
        }).disposed(by: disposeBag)
    }
    
    // MARK: Loading more words by pages
    func loadMoreWords() {
        if let query = currentQuery, let page = loadedPages {
            self.isLoadingMore = true
            translateService.getTranslateList(query: query, page: page + 1).subscribe(onNext: { [weak self] (response) in
                guard let `self` = self else { return }
                if response.first?.id == 0 || response.isEmpty {
                    self.isFinished = true
                    let value = self.words.value + []
                    self.words.accept(value)
                } else {
                    self.loadedPages = page + 1
                    let value = self.words.value + response
                    self.words.accept(value)
                }
                self.isLoadingMore = false
            }, onError: { [weak self] (error) in
                guard let `self` = self else { return }
                self.error.accept(error.localizedDescription)
                self.isLoadingMore = false
            }).disposed(by: disposeBag)
        }
    }
    
    // MARK: Clear viewModel observables for new searching
    func clearAllModel() {
        self.words.accept([])
        self.isLoading.accept(false)
        self.isLoadingMore = false
        self.loadedPages = nil
        self.currentQuery = nil
        self.isFinished = false
    }
    
}
