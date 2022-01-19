//
//  CardTableViewCell.swift
//  Skripsi AMIN
//
//  Created by Vivian Angela on 30/12/21.
//

import UIKit

protocol CardTableViewDelegate{
    
    func passData(key: String)
    
}

class CardTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var cardCollection: UICollectionView!
    
    var delegate: CardTableViewDelegate?
    var vc: UIViewController!
    var tempModelCTab: [Content] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        cardCollection.register(UINib(nibName: "\(CardCollectionViewCell.self)", bundle: nil), forCellWithReuseIdentifier: "cardCollectionCell")
        
        cardCollection.delegate = self
        cardCollection.dataSource = self
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension CardTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tempModelCTab.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = cardCollection.dequeueReusableCell(withReuseIdentifier: "cardCollectionCell", for: indexPath) as! CardCollectionViewCell
        cell.tempModelCCol = tempModelCTab[indexPath.row]
        cell.layer.cornerRadius = 10
//        cell.layer.shadowColor = UIColor.black.cgColor
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 120, height: 150)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.passData(key: tempModelCTab[indexPath.row].detailKey)
    }
    
    
    
    
}
