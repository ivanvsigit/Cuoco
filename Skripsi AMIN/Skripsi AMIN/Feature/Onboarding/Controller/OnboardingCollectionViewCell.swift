//
//  OnboardingCollectionViewCell.swift
//  Cuoco
//
//  Created by Vivian Angela on 26/01/22.
//

import UIKit

class OnboardingCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var onboardingImage: UIImageView!
    
    var image: String? {
        didSet {
            guard let img = image else { return }
            onboardingImage.image = UIImage(named: img)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

}
