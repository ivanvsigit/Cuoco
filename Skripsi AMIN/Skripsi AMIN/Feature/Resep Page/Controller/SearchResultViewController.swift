//
//  SearchResultViewController.swift
//  Skripsi AMIN
//
//  Created by Vivian Angela on 13/01/22.
//

import UIKit

class SearchResultViewController: UIViewController {

    @IBOutlet weak var searchResultCollection: UICollectionView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var filterBtn: UIButton!
    @IBAction func filterBtn(_ sender: Any) {
    }
    
    let imageIcon: UIImageView = {
       let image = UIImageView(frame: CGRect(x: 8, y: 0, width: 16, height: 16))
        image.image = UIImage(systemName: "magnifyingglass")
        
        return image
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        view.backgroundColor = .systemPink
        navigationController?.isNavigationBarHidden = true
        searchResultCollection.register(UINib(nibName: "\(SimpanCollectionViewCell.self)", bundle: nil), forCellWithReuseIdentifier: "simpanCollectionCell")
      
        self.hideKeyboardWhenTappedAround()
        
        filterBtn.tintColor = UIColor(named: "PrimaryColor")
        
        search()
    }
    
    func search() {
        searchTextField.delegate = self
        searchTextField.leftViewMode = .always
        searchTextField.leftView = imageIcon
        searchTextField.leftView?.tintColor = UIColor(named: "TextColor")
        searchTextField.layer.cornerRadius = 10
        searchTextField.backgroundColor = UIColor(named: "SecondaryTintColor")
        searchTextField.layer.borderWidth = 1
        searchTextField.layer.borderColor = UIColor.white.cgColor
        searchTextField.clipsToBounds = true
        searchTextField.addTarget(self, action: #selector(ResepViewController.textFieldDidChange(_:)), for: .editingChanged)
        searchTextField.attributedPlaceholder = NSAttributedString(string: "Pencarian", attributes: [NSAttributedString.Key.foregroundColor: UIColor(named: "TextColor")!])
        searchTextField.font = UIFont(name: "Poppins-Regular", size: 17)
    }

}

extension SearchResultViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = searchResultCollection.dequeueReusableCell(withReuseIdentifier: "simpanCollectionCell", for: indexPath) as! SimpanCollectionViewCell

        cell.layer.cornerRadius = 10

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 164, height: 200)
    }

}

extension SearchResultViewController: UITextFieldDelegate, UISearchBarDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        if searchTextField.text?.count!= 0 {
//            self.filteredData.removeAll()
//        }
        
        searchTextField.endEditing(true)
//        navigationController?.isNavigationBarHidden = false
        return true
    }
    
     // MARK: while editing will display another view
    func textFieldDidBeginEditing(_ textField: UITextField) {
    }
    
     
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if searchTextField.text != "" {
            return true
        }
        else {
            searchTextField.placeholder = "Masukan Kata Kunci"
            return false
        }
    }
    
     // MARK: Func after done editing
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if let data = searchTextField.text {
            //TODO: Func fetch data
            data.lowercased().range(of: searchTextField.text!, options: .caseInsensitive, range: nil, locale: nil)
        }
        
        searchTextField.text = ""
        
//        willMove(toParent: nil)
//        vc.view.removeFromSuperview()
    }
    
    func hideKeyboardWhenTappedAround() {
         // MARK: Looks for single or multiple taps
        let tap = UITapGestureRecognizer(target: self, action: #selector(SearchResultViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
     // MARK: Calls this function when the tap is recognized
    @objc func dismissKeyboard() {
         // MARK: Causes the view (or one of its embedded text fields) to resign the first responder status
        view.endEditing(true)
    }
}

