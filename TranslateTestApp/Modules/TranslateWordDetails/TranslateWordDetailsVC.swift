//
//  TranslateWordDetailsVC.swift
//  TranslateTestApp


import UIKit

class TranslateWordDetailsVC: UIViewController {

    //MARK: - IBOutlets
    @IBOutlet weak var wordImage: UIImageView!
    @IBOutlet weak var word: UILabel!
    @IBOutlet weak var translate: UILabel!
    @IBOutlet weak var transcription: UILabel!
    
    var wordCombination: WordCombination!
    
    //MARK: - View cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    private func setup() {
        if wordCombination == nil {
            self.dismiss(animated: false, completion: nil)
        } else if let wordCombination = wordCombination {
            setupViews(wordCombination)
        }
    }
    
    private func setupViews(_ wordCombination: WordCombination) {
        self.word.text = wordCombination.text
        self.transcription.text = wordCombination.meanings.first?.transcription
        self.wordImage.image = nil
        self.translate.text = ""
        wordCombination.meanings.forEach { (meaning) in
            if meaning.translation.text != "" {
                self.translate.text! += "• " + meaning.translation.text + "; "
            }
        }
        if self.translate.text != "" {
            self.translate.text?.removeLast()
            self.translate.text?.removeLast()
            self.translate.text! += "."
        }
        if let url = wordCombination.meanings.first?.imageUrl {
            
            loadImage(url: "https:" + url)
        }
    }
    
    private func loadImage(url: String) {
        let url = URL(string: url)!
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url) {
                DispatchQueue.main.async {
                    self.wordImage.image = UIImage(data: data)
                }
            }
        }
    }

}

//MARK: - Storyboard instance
extension TranslateWordDetailsVC {
    static unowned var storyboardInstance: TranslateWordDetailsVC {
        return UIStoryboard(name: String(describing: self), bundle: nil).instantiateInitialViewController() as! TranslateWordDetailsVC
    }
}


