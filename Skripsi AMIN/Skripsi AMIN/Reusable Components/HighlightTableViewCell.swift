//
//  HighlightTableViewCell.swift
//  Skripsi AMIN
//
//  Created by Vivian Angela on 30/12/21.
//

import UIKit

class HighlightTableViewCell: UITableViewCell {

    @IBOutlet weak var highlightCollection: UICollectionView!
    @IBOutlet weak var highlightPageController: UIPageControl!
    
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//
//    }
//
    
    override func awakeFromNib() {
        super.awakeFromNib()
        highlightCollection.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "test")
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension HighlightTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = highlightCollection.dequeueReusableCell(withReuseIdentifier: "test", for: indexPath) as! HightlightCollectionViewCell
        
        return cell
    }
    
    
}
