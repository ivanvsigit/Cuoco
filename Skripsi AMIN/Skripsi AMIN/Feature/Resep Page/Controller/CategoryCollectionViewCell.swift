//
//  CategoryCollectionViewCell.swift
//  Cuoco
//
//  Created by Vivian Angela on 23/01/22.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var categoryImage: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!
    
    var categoryData: Content? {
        didSet {
            setUpContent()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        categoryLabel.font = UIFont(name: "Poppins-Medium", size: 12)
        categoryLabel.textColor = UIColor(named: "TextColor")
        categoryLabel.baselineAdjustment = .alignCenters
    }
    
    func setUpContent() {
        guard let data = categoryData else { return }
        categoryImage.image = data.image
        categoryLabel.text = data.label
    }

}
