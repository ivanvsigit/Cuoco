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
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        view.backgroundColor = .systemPink
        searchResultCollection.register(UINib(nibName: "\(CardCollectionViewCell.self)", bundle: nil), forCellWithReuseIdentifier: "cardCollectionCell")
      
//        self.hideKeyboardWhenTappedAround()
        
        searchBar.sizeToFit()
        navigationItem.title = "hasil"
        navigationItem.titleView = searchBar
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "slider.horizontal.3"), style: .plain, target: self, action: #selector(showFilter))
        searchBar.backgroundColor = UIColor(named: "SecondaryTintColor")
        searchBar.placeholder = "Pencarian"
        searchBar.tintColor = UIColor(named: "PrimaryColor")
        navigationItem.rightBarButtonItem?.tintColor = UIColor(named: "PrimaryColor")
        searchBar.delegate = self
        
//        API.shared.fetchSearchResultDataAPI(urlKey: Constant.shared.searchKey) {
//            for data in Constant.shared.search {
//                self.filteredData.append(Content(image: UIImage(data: Constant.shared.getImage(urlKey: data.thumb))!, label: data.title))
//            }
//            DispatchQueue.main.async {
//                self.searchResultCollection.reloadData()
//            }
//        }

        
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(true)
//
//        API.shared.fetchSearchResultDataAPI(urlKey: Constant.shared.searchKey) {
//            for data in Constant.shared.search {
//                self.filteredData.append(Content(image: UIImage(data: Constant.shared.getImage(urlKey: data.thumb))!, label: data.title))
//            }
//            DispatchQueue.main.async {
//                self.searchResultCollection.reloadData()
//            }
//            Constant.shared.searchKey = ""
//        }
//    }
    
    @objc func showFilter() {
        
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

}

extension SearchResultViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
        navigationItem.setHidesBackButton(true, animated: false)
        searchBar.becomeFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty{
            filteredData.removeAll()
            searchResultCollection.reloadData()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let safe_text = searchBar.text else { return  }
        API.shared.fetchSearchResultDataAPI(urlKey: safe_text) {
            self.filteredData.removeAll()
                for data in Constant.shared.search{
                    self.filteredData.append(Content(image: UIImage(data: Constant.shared.getImage(urlKey: data.thumb))!, label: data.title, detailKey: data.key))
                }
            
            DispatchQueue.main.async {
                self.searchResultCollection.reloadData()
            }
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        navigationController?.popViewController(animated: false)
    }
    
//    func hideKeyboardWhenTappedAround() {
//         // MARK: Looks for single or multiple taps
//        let tap = UITapGestureRecognizer(target: self, action: #selector(SearchResultViewController.dismissKeyboard))
//        tap.cancelsTouchesInView = false
//        view.addGestureRecognizer(tap)
//    }
//
//     // MARK: Calls this function when the tap is recognized
//    @objc func dismissKeyboard() {
//         // MARK: Causes the view (or one of its embedded text fields) to resign the first responder status
//        view.endEditing(true)
//    }
}

