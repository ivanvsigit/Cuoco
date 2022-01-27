//
//  SimpanViewController.swift
//  Skripsi AMIN
//
//  Created by Vivian Angela on 30/12/21.
//

import UIKit

class SimpanViewController: UIViewController {

    @IBOutlet weak var simpanCollection: UICollectionView!

    var simpanDetail: [CoreDetail] = []
    var filteredData: [CoreDetail] = []
    var editState = false
    
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
    
    let kosong = UILabel(frame: CGRect(x: 20, y: 450, width: 350, height: 50))
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        self.hideKeyboardWhenTappedAround()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            DataManipulation.shared.model.removeAll()
            DataManipulation.shared.getItem()
            self.fetchData()
            self.simpanCollection.reloadData()
        }
        tabBarController?.tabBar.isHidden = false
    }
    
    func setUp() {
        simpanCollection.register(UINib(nibName: "\(SimpanCollectionViewCell.self)", bundle: nil), forCellWithReuseIdentifier: "simpanCollectionCell")
        simpanCollection.delegate = self
        simpanCollection.dataSource = self
        
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor(named: "TextColor")!, .font: UIFont(name: "Poppins-SemiBold", size: 17)!]
      
        navigationItem.titleView = searchBar
        
        searchBar.delegate = self
        searchBar.searchTextField.backgroundColor = UIColor(named: "SecondaryTintColor")
        searchBar.placeholder = "Pencarian"
        searchBar.tintColor = UIColor(named: "PrimaryColor")
    }
    
     // MARK: Retrieve from Core Data
    func fetchData(){
        simpanDetail.removeAll()
        for model in DataManipulation.shared.model {
            if model.saved == true {
                let data = CoreDetail(image: model.image, label: model.label!, key: model.key, saved: model.saved)
//                var temp = 0
//                for i in 0..<simpanDetail.count{
//                    if simpanDetail[i].key == data.key {
//                        temp = 1
//                        break
//                    }
//                }
                
//                if temp == 0 {
                    self.simpanDetail.append(data)
//                }
            }
        }
        
        if simpanDetail.count == 0 {
            self.view.addSubview(self.emptyState)
            self.view.addSubview(self.kosong)
            self.emptyState.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
            self.emptyState.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
            self.emptyState.heightAnchor.constraint(equalToConstant: 200).isActive = true
            self.emptyState.widthAnchor.constraint(equalToConstant: 200).isActive = true
            self.kosong.text = "Belum ada resep yang tersimpan, ayo simpan resep yang kamu inginkan!"
            self.kosong.textAlignment = .center
            self.kosong.font = UIFont(name: "Poppins-Regular", size: 14)
            self.kosong.textColor = .systemGray
            self.kosong.numberOfLines = 0
        }
        
        print("print history")
        print(simpanDetail)
    }
}

extension SimpanViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, simpanColDelegate  {
    func triggerReloadCollection() {
        
        DispatchQueue.main.async {
            DataManipulation.shared.model.removeAll()
            DataManipulation.shared.getItem()
            self.simpanDetail.removeAll()
            self.fetchData()
            self.simpanCollection.reloadData()
        }
        
        print("delegate oke")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if editState == true {
            return filteredData.count
        }
        return simpanDetail.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = simpanCollection.dequeueReusableCell(withReuseIdentifier: "simpanCollectionCell", for: indexPath) as! SimpanCollectionViewCell
        cell.layer.cornerRadius = 10
        cell.vc = self
        cell.delegate = self
        if editState == true {
            cell.tempModelSCol = filteredData[indexPath.row]
            return cell
        }
        else if editState == false {
            cell.tempModelSCol = simpanDetail[indexPath.row]
            return cell
        }
        else{
            return UICollectionViewCell()
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 164, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = ResepDetailViewController()
        if editState == true {
            vc.resepKey = filteredData[indexPath.row].key
            navigationController?.pushViewController(vc, animated: true)
        }
        else {
            vc.resepKey = simpanDetail[indexPath.row].key
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}

extension SimpanViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        editState = true
        searchBar.showsCancelButton = true
        
        DispatchQueue.main.async {
            self.simpanCollection.reloadData()
        }
    }
  
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        filteredData.removeAll()
        
        guard let safe_text = searchBar.text else { return }
        for data in simpanDetail {
            guard let lbl_data = data.label else { return  }
            if lbl_data.contains(safe_text)  {
                self.filteredData.append(data)
            }
        }
        
        DispatchQueue.main.async {
            if self.filteredData.count == 0 {
                self.view.addSubview(self.emptyState)
                self.emptyState.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
                self.emptyState.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
                self.emptyState.heightAnchor.constraint(equalToConstant: 200).isActive = true
                self.emptyState.widthAnchor.constraint(equalToConstant: 200).isActive = true
            }
            else {
                self.emptyState.removeFromSuperview()
            }
            self.simpanCollection.reloadData()
        }
       
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        guard let search_Text = searchText else { return }
        if searchText.count < 1 {
            filteredData.removeAll()
        }
        DispatchQueue.main.async {
            self.simpanCollection.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        editState = false
        searchBar.showsCancelButton = false
        searchBar.text = ""
        DispatchQueue.main.async {
            self.emptyState.removeFromSuperview()
            self.simpanCollection.reloadData()
        }
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
        searchBar.endEditing(true)
    }
}

