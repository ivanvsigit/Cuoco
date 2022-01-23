//
//  CategoryViewController.swift
//  Cuoco
//
//  Created by Vivian Angela on 24/01/22.
//

import UIKit

class CategoryViewController: UIViewController {

    @IBOutlet weak var categoryCollectionResult: UICollectionView!
    
    var categoryData: [Content] = []
    var categoryKey = ""
    var categoryTitle = ""
    
    let imgLoad: UIImageView = {
       let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.animationImages = (0...5).map ({
            value in return UIImage(named: "animated-1-\(value)") ?? UIImage()
        })
        image.animationRepeatCount = -1
        image.animationDuration = 1
        image.startAnimating()
        
        return image
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        fetchData(key: categoryKey)
    }
    
    func setUp() {
        categoryCollectionResult.register(UINib(nibName: "\(CardCollectionViewCell.self)", bundle: nil), forCellWithReuseIdentifier: "cardCollectionCell")
         // MARK: GK JALAN
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(named: "SecondaryColor")!, NSAttributedString.Key.font: UIFont(name: "Poppins-SemiBold", size: 17)!]
        navigationItem.title = categoryTitle
        
        tabBarController?.tabBar.isHidden = true
        tabBarController?.tabBar.isTranslucent = true
    }
    
    func fetchData(key: String) {
        DispatchQueue.main.async {
            self.view.addSubview(self.imgLoad)
            self.imgLoad.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
            self.imgLoad.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
            self.imgLoad.heightAnchor.constraint(equalToConstant: 200).isActive = true
            self.imgLoad.widthAnchor.constraint(equalToConstant: 200).isActive = true
            
            self.categoryData.removeAll()
            self.categoryCollectionResult.reloadData()
        }
        API.shared.fetchDataAPI(urlKey: key) {
            for content in Constant.shared.data {
                self.categoryData.append(Content(image: UIImage(data: Constant.shared.getImage(urlKey: content.thumb))!, label: content.title, detailKey: content.key))
            }
            
            DispatchQueue.main.async {
                self.categoryCollectionResult.reloadData()
                self.imgLoad.removeFromSuperview()

            }
        }
    }

}

extension CategoryViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryData.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = categoryCollectionResult.dequeueReusableCell(withReuseIdentifier: "cardCollectionCell", for: indexPath) as! CardCollectionViewCell
        cell.tempModelCCol = categoryData[indexPath.row]
        cell.layer.cornerRadius = 10

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 164, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = ResepDetailViewController()
        vc.resepKey = categoryData[indexPath.row].detailKey
        print(categoryData[indexPath.row].detailKey)
        navigationController?.pushViewController(vc, animated: true)
        
    }

}
