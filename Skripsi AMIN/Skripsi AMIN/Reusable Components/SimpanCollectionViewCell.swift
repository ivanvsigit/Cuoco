//
//  SimpanCollectionViewCell.swift
//  Skripsi AMIN
//
//  Created by Vivian Angela on 13/01/22.
//

import UIKit

class SimpanCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var simpanView: UIView!
    @IBOutlet weak var simpanImage: UIImageView!
    @IBOutlet weak var simpanLabelBG: UIView!
    @IBOutlet weak var simpanLabel: UILabel!
    @IBAction func simpanBtn(_ sender: Any) {
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        simpanLabelBG.backgroundColor = UIColor(named: "SecondaryColor")
    }

}
