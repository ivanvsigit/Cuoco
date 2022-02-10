//
//  SearchResultViewController.swift
//  Skripsi AMIN
//
//  Created by Vivian Angela on 13/01/22.
//

import UIKit

class SearchResultViewController: UIViewController {

    @IBOutlet weak var searchResultCollection: UICollectionView!
   
    var filteredData: [Content] = []
    let searchBar = UISearchBar()
    
    let emptyState: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.animationImages = (0...4).map ({
            value in return UIImage(named: "animated-2-\(value)") ?? UIImage()
        })
        image.animationRepeatCount = -1
        image.animationDuration = 1
        image.startAnimating()

        return image
    }()
    
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
        self.hideKeyboardWhenTappedAround()
        
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).title = "Batal"
    }
    
    func setUp() {
        searchResultCollection.register(UINib(nibName: "\(CardCollectionViewCell.self)", bundle: nil), forCellWithReuseIdentifier: "cardCollectionCell")
      
        navigationItem.titleView = searchBar
        navigationItem.rightBarButtonItem?.tintColor = UIColor(named: "PrimaryColor")
        
        searchBar.placeholder = "Pencarian"
        searchBar.tintColor = UIColor(named: "PrimaryColor")
        searchBar.delegate = self
        
        searchResultCollection.keyboardDismissMode = .onDrag
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        searchBar.becomeFirstResponder()
    }

}

extension SearchResultViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredData.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = searchResultCollection.dequeueReusableCell(withReuseIdentifier: "cardCollectionCell", for: indexPath) as! CardCollectionViewCell
        cell.tempModelCCol = filteredData[indexPath.row]
        cell.layer.cornerRadius = 10

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 164, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = ResepDetailViewController()
        vc.resepKey = filteredData[indexPath.row].detailKey
        print(vc.resepKey)
        navigationController?.pushViewController(vc, animated: true)
    }

}

extension SearchResultViewController: UISearchBarDelegate, UITextFieldDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty{
            filteredData.removeAll()
            searchResultCollection.reloadData()
            emptyState.removeFromSuperview()
        }
        emptyState.removeFromSuperview()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let safe_text = searchBar.text else { return  }
        let trimText = safe_text.replacingOccurrences(of: " ", with: "%20")
        
        DispatchQueue.main.async {
            self.emptyState.removeFromSuperview()
            self.view.addSubview(self.imgLoad)
            self.imgLoad.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
            self.imgLoad.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
            self.imgLoad.heightAnchor.constraint(equalToConstant: 200).isActive = true
            self.imgLoad.widthAnchor.constraint(equalToConstant: 200).isActive = true
            
            self.filteredData.removeAll()
            self.searchResultCollection.reloadData()
        }
       
        API.shared.fetchSearchResultDataAPI(urlKey: trimText) {
            self.filteredData.removeAll()
                for data in Constant.shared.search{
                    self.filteredData.append(Content(image: UIImage(data: Constant.shared.getImage(urlKey: data.thumb))!, label: data.title, detailKey: data.key))
                }
            
            DispatchQueue.main.async {
                if self.filteredData.count == 0 {
                    self.view.addSubview(self.emptyState)
                    self.emptyState.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
                    self.emptyState.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
                    self.emptyState.heightAnchor.constraint(equalToConstant: 200).isActive = true
                    self.emptyState.widthAnchor.constraint(equalToConstant: 200).isActive = true
                }
                self.searchResultCollection.reloadData()
                self.imgLoad.removeFromSuperview()
            }
        }
        
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.dismiss(animated: false, completion: nil)
    }
    
    func hideKeyboardWhenTappedAround() {
         // MARK: Looks for single or multiple taps
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

     // MARK: Calls this function when the tap is recognized
    @objc func dismissKeyboard() {
         // MARK: Causes the view (or one of its embedded text fields) to resign the first responder status
//        view.endEditing(true)
        searchBar.endEditing(true)
    }
    
}

