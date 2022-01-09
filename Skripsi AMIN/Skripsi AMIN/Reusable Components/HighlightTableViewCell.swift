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
    
    var tempModelHTab: [Content] = []
    
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//
//    }
    
//    var delay = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(autoScroll), userInfo: nil, repeats: true)
    
    var currentIndex = 0 {
        didSet {
            highlightPageController.currentPage = currentIndex
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        highlightCollection.register(UINib(nibName: "\(HighlightCollectionViewCell.self)", bundle: nil), forCellWithReuseIdentifier: "highlightCollectionCell")
        highlightCollection.delegate = self
        highlightCollection.dataSource = self
    
        
//        highlightPageController.numberOfPages = tempModelHTab.count
        highlightPageController.pageIndicatorTintColor = UIColor(named: "SecondaryTintColor")
        highlightPageController.currentPageIndicatorTintColor = UIColor(named: "PrimaryColor")
        
//        Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(autoScroll), userInfo: nil, repeats: true)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
//    @objc func autoScroll() {
//        let index = NSIndexPath(index: 2)
//        highlightCollection.scrollToItem(at: index as IndexPath, at: .centeredHorizontally, animated: true)
//    }
        
}

extension HighlightTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tempModelHTab.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = highlightCollection.dequeueReusableCell(withReuseIdentifier: "highlightCollectionCell", for: indexPath) as! HighlightCollectionViewCell
        cell.tempModelHCol = tempModelHTab[indexPath.row]
        cell.layer.cornerRadius = 10
    
        return cell
    }
    
    // MARK: give collection view cell size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        collectionView.leadingAnchor.constraint(equalTo: collectionView.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: collectionView.trailingAnchor).isActive = true
        
//        return CGSize(width: 350, height: 100)
         // MARK: give cell the same size with collection view
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        let totalCellWidth = 350 * 5
//        let totalSpacingWidth = 20 * (5 - 1)
//
//        let leftInset = (390 - CGFloat(totalCellWidth + totalSpacingWidth)) / 2
//        let rightInset = leftInset
//
//        return UIEdgeInsets(top: 0, left: leftInset, bottom: 0, right: rightInset)
//    }
    
     // MARK: give the highlight page for the page controller
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        self.highlightPageController.currentPage = indexPath.row
    }
    
    
}
