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
    var simpanDetail: [CoreDetail] = []
    
    let searchBar = UISearchBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DataManipulation.shared.getItem()
        setUp()
        fetchData()
        self.hideKeyboardWhenTappedAround()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
    }
    
    func setUp() {
        simpanCollection.register(UINib(nibName: "\(SimpanCollectionViewCell.self)", bundle: nil), forCellWithReuseIdentifier: "simpanCollectionCell")
        simpanCollection.delegate = self
        simpanCollection.dataSource = self
        
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor(named: "TextColor")!, .font: UIFont(name: "Poppins-SemiBold", size: 17)!]
      
        navigationItem.titleView = searchBar
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "slider.horizontal.3"), style: .plain, target: self, action: #selector(showFilter))
        navigationItem.rightBarButtonItem?.tintColor = UIColor(named: "PrimaryColor")
        
        searchBar.delegate = self
        searchBar.searchTextField.backgroundColor = UIColor(named: "SecondaryTintColor")
        searchBar.placeholder = "Pencarian"
        searchBar.tintColor = UIColor(named: "PrimaryColor")

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
        //TODO: Show modal filter
    }
    
    func fetchData(){
        for model in DataManipulation.shared.model {
            if model.saved == true {
                let data = CoreDetail(image: model.image, label: model.label!, key: model.key, saved: model.saved)
                self.simpanDetail.append(data)
            }
        }
        
        print("print history")
        print(simpanDetail)
    }
}

extension SimpanViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(simpanDetail.count)
        return simpanDetail.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = simpanCollection.dequeueReusableCell(withReuseIdentifier: "simpanCollectionCell", for: indexPath) as! SimpanCollectionViewCell
        cell.layer.cornerRadius = 10
        cell.tempModelSCol = simpanDetail[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 164, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = ResepDetailViewController()
        vc.resepKey = simpanDetail[indexPath.row].key
        print(vc.resepKey)
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension SimpanViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
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

