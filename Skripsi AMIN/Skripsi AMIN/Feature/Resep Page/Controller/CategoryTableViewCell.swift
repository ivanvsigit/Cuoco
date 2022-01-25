//
//  CategoryTableViewCell.swift
//  Cuoco
//
//  Created by Vivian Angela on 23/01/22.
//

import UIKit

protocol CategoryTableViewDelegate {
    func passDataCategory(key: String, index: Int)
}

class CategoryTableViewCell: UITableViewCell {

    @IBOutlet weak var categoryCollection: UICollectionView!
    
    var categoryData: [Content] = []
    var delegate: CategoryTableViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        categoryCollection.register(UINib(nibName: "\(CategoryCollectionViewCell.self)", bundle: nil), forCellWithReuseIdentifier: "categoryCollectionCell")
        
        categoryCollection.delegate = self
        categoryCollection.dataSource = self
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension CategoryTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = categoryCollection.dequeueReusableCell(withReuseIdentifier: "categoryCollectionCell", for: indexPath) as! CategoryCollectionViewCell
        cell.categoryData = categoryData[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 77, height: 96)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.passDataCategory(key: categoryData[indexPath.row].detailKey, index: indexPath.row)
    }
    
}
