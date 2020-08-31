//
//  WordCombinationCell.swift
//  TranslateTestApp


import UIKit

class WordCombinationCell: UITableViewCell {
    
    static let identifier = "WordCombinationCell"

    @IBOutlet weak var word: UILabel!
    @IBOutlet weak var translate: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
