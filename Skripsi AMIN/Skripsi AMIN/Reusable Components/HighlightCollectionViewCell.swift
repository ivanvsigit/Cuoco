//
//  HighlightCollectionViewCell.swift
//  Skripsi AMIN
//
//  Created by Vivian Angela on 04/01/22.
//

import UIKit

class HighlightCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var highlightView: UIView!
    @IBOutlet weak var highlightImage: UIImageView!
    @IBOutlet weak var highlightLabel: UILabel!
    @IBOutlet weak var highlightLabelBG: UIView!
    
     // MARK: Property Observer 
    var tempModelHCol: Content? {
        didSet {
            setupContent()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        highlightView.backgroundColor = UIColor(named: "SecondaryColor")
        highlightLabelBG.backgroundColor = UIColor(named: "SecondaryColor")
       
        
    }
    
    func setupContent() {
        guard let data = tempModelHCol else { return }
        highlightImage.image = data.image
        highlightLabel.text = data.label
    }

}
