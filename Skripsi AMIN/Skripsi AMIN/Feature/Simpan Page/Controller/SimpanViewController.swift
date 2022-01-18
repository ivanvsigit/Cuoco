//
//  SimpanViewController.swift
//  Skripsi AMIN
//
//  Created by Vivian Angela on 30/12/21.
//

import UIKit

class SimpanViewController: UIViewController {

    @IBOutlet weak var simpanCollection: UICollectionView!
    
    
//    let imageIcon: UIImageView = {
//       let image = UIImageView(frame: CGRect(x: 8, y: 0, width: 16, height: 16))
//        image.image = UIImage(systemName: "magnifyingglass")
//
//        return image
//    }()
    
    let searchBar = UISearchController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        simpanCollection.register(UINib(nibName: "\(SimpanCollectionViewCell.self)", bundle: nil), forCellWithReuseIdentifier: "simpanCollectionCell")
        simpanCollection.delegate = self
        simpanCollection.dataSource = self
        
        navigationItem.title = "Simpan"
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor(named: "TextColor")!, .font: UIFont(name: "Poppins-SemiBold", size: 17)!]
        navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor(named: "TextColor")!, .font: UIFont(name: "Poppins-Bold", size: 32)!]
        //TODO: Navbar don't scroll
        
        setUpSearch()
        self.hideKeyboardWhenTappedAround()
    }
    
    func setUpSearch() {
        navigationItem.searchController = searchBar
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "slider.horizontal.3"), style: .plain, target: self, action: #selector(showFilter))
        searchBar.searchBar.searchTextField.backgroundColor = UIColor(named: "SecondaryTintColor")
        searchBar.searchBar.placeholder = "Pencarian"
        searchBar.searchBar.tintColor = UIColor(named: "PrimaryColor")
        navigationItem.rightBarButtonItem?.tintColor = UIColor(named: "PrimaryColor")
        searchBar.searchResultsUpdater = self
        searchBar.searchBar.delegate = self

         // MARK: Custom search
//        searchTextField.delegate = self
//        searchTextField.leftViewMode = .always
//        searchTextField.leftView = imageIcon
//        searchTextField.leftView?.tintColor = UIColor(named: "TextColor")
//        searchTextField.layer.cornerRadius = 10
//        searchTextField.backgroundColor = UIColor(named: "SecondaryTintColor")
//        searchTextField.layer.borderWidth = 1
//        searchTextField.layer.borderColor = UIColor.white.cgColor
//        searchTextField.clipsToBounds = true
//        searchTextField.attributedPlaceholder = NSAttributedString(string: "Pencarian", attributes: [NSAttributedString.Key.foregroundColor: UIColor(named: "TextColor")!])
//        searchTextField.font = UIFont(name: "Poppins-Regular", size: 17)
        
    }
    
    @objc func showFilter() {
        
    }
    
}

extension SimpanViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = simpanCollection.dequeueReusableCell(withReuseIdentifier: "simpanCollectionCell", for: indexPath) as! SimpanCollectionViewCell
        
        cell.layer.cornerRadius = 10
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 164, height: 200)
    }
    
}

extension SimpanViewController: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        searchTextField.endEditing(true)
//        return true
//    }
//
//    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
//        if searchTextField.text != "" {
//            return true
//        }
//        else {
//            searchTextField.placeholder = "Masukan Kata Kunci"
//            return false
//        }
//    }
//
//     // MARK: Func after done editing
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        if let data = searchTextField.text {
//            //TODO: Func fetch data
//        }
//        searchTextField.text = ""
//    }
    
    func hideKeyboardWhenTappedAround() {
         // MARK: Looks for single or multiple taps
        let tap = UITapGestureRecognizer(target: self, action: #selector(SimpanViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
     // MARK: Calls this function when the tap is recognized
    @objc func dismissKeyboard() {
         // MARK: Causes the view (or one of its embedded text fields) to resign the first responder status
        view.endEditing(true)
    }
}

