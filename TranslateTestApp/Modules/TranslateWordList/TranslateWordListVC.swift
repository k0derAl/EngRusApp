//
//  TranslateWordListVC.swift
//  TranslateTestApp


import UIKit
import RxSwift
import RxCocoa

class TranslateWordListVC: UIViewController {
    
    
    
    //MARK: - IBOutlets
    @IBOutlet weak var resultsTableView: UITableView! {
        didSet {
            resultsTableView.register(UINib(nibName: LoadingCell.identifier, bundle: nil), forCellReuseIdentifier: LoadingCell.identifier)
            resultsTableView.register(UINib(nibName: WordCombinationCell.identifier, bundle: nil), forCellReuseIdentifier: WordCombinationCell.identifier)
        }
    }
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private let translateListViewModel: TranslateWordListViewModelProtocol = TranslateWordListViewModel()
    private let disposeBag = DisposeBag()
    private let searchBar = UISearchBar()
    
    //MARK: - View cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        setupSearchBar()
        setupNavigaitonBar()
        bind(to: translateListViewModel)
    }
    
    // MARK: Binding with SearchViewModel
    private func bind(to viewModel: TranslateWordListViewModelProtocol) {
        // Articles
        viewModel.words
            .asDriver()
            .drive(onNext: { [weak self] words in
                guard let `self` = self else { return }
                self.resultsTableView.reloadData()
            })
            .disposed(by: disposeBag)
        
        // Loading
        viewModel.isLoading
            .asDriver()
            .drive(onNext: { [weak self] loading in
                guard let `self` = self else { return }
                self.activityIndicator.isHidden = !loading
                if self.activityIndicator.isHidden == false {
                    self.activityIndicator.startAnimating()
                }  })
            .disposed(by: disposeBag)

        // Error
        viewModel.error
            .asDriver(onErrorJustReturn: "Error")
            .drive(onNext: { [weak self] (error) in
                guard let `self` = self else { return }
                self.showErrorAlert(title: "Error", message: error)
            })
            .disposed(by: disposeBag)
    }
    
    private func setupSearchBar() {
        searchBar.searchTextField.becomeFirstResponder()
        searchBar.placeholder = "Search articale"
        searchBar.tintColor = .black
        searchBar.delegate = self
        searchBar.searchTextField.delegate = self
        searchBar.showsCancelButton = true
    }
    
    private func setupNavigaitonBar() {
        navigationItem.titleView = searchBar
        navigationItem.hidesBackButton = true
        navigationController?.navigationBar.tintColor = .black
        navigationItem.titleView = searchBar
    }
}


// MARK: UITableViewDelegate, UITableViewDataSource
extension TranslateWordListVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return translateListViewModel.words.value.count
        } else if section == 1, translateListViewModel.isLoadingMore == true, !translateListViewModel.isFinished {
            return 1
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "WordCombinationCell", for: indexPath) as? WordCombinationCell else {
                return UITableViewCell()
            }
            let wordCombination = translateListViewModel.words.value[indexPath.row]
            cell.word.text = wordCombination.text
            cell.translate.text = wordCombination.meanings.first?.translation.text
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "LoadingCell", for: indexPath) as? LoadingCell else {
                return UITableViewCell()
            }
            cell.activityIndicator.startAnimating()
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailsVC = TranslateWordDetailsVC.storyboardInstance
        detailsVC.wordCombination = translateListViewModel.words.value[indexPath.row]
        navigationController?.pushViewController(detailsVC, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        if offsetY > contentHeight - scrollView.frame.height {
            if !translateListViewModel.isLoadingMore, !translateListViewModel.words.value.isEmpty, !translateListViewModel.isFinished {
                translateListViewModel.loadMoreWords()
                resultsTableView.reloadSections(IndexSet(integer: 1), with: .none)
            }
        }
    }
    

}

//MARK: - UISearchBarDelegate
extension TranslateWordListVC: UISearchBarDelegate, UITextFieldDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.text?.count ?? 1 > 1 {
            self.translateListViewModel.searchWords(query: searchBar.text!)
            searchBar.endEditing(true)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        self.translateListViewModel.clearAllModel()
        return true
    }
}

//MARK: - Storyboard instance
extension TranslateWordListVC {
    static unowned var storyboardInstance: TranslateWordListVC {
        return UIStoryboard(name: String(describing: self), bundle: nil).instantiateInitialViewController() as! TranslateWordListVC
    }
}
