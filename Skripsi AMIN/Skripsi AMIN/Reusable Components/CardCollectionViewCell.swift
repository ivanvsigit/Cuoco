//
//  CardCollectionViewCell.swift
//  Skripsi AMIN
//
//  Created by Vivian Angela on 05/01/22.
//

import UIKit

protocol HistoryColDelegate {
    func triggerReloadCollection()
}

class CardCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var cardImage: UIImageView!
    @IBOutlet weak var cardLabelBG: UIView!
    @IBOutlet weak var cardLabel: UILabel!
    
    // MARK: Property Observer 
    var tempModelCCol: Content? {
        didSet {
            setupContent()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        cardView.layer.cornerRadius = 10
//        cardView.backgroundColor = UIColor(named: "SecondaryColor")
        cardLabelBG.backgroundColor = UIColor(named: "SecondaryColor")
        cardLabel.font = UIFont(name: "Poppins-Medium", size: 14)
        cardLabel.textColor = UIColor(named: "TextColor")
        
    }
    
     // MARK: Set Up Data Model to Var
    func setupContent() {
        guard let data = tempModelCCol else { return }
        cardImage.image = data.image
        let newTitle = data.label.components(separatedBy: ",")
        print(newTitle)
        cardLabel.text = newTitle[0]
    }

}
