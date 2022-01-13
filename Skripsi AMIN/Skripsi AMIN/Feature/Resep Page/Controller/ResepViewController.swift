//
//  ResepViewController.swift
//  Skripsi AMIN
//
//  Created by Vivian Angela on 30/12/21.
//

import UIKit
import AVFoundation

class ResepViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var filterBtn: UIButton!
    
    let imageIcon: UIImageView = {
       let image = UIImageView(frame: CGRect(x: 8, y: 0, width: 16, height: 16))
        image.image = UIImage(systemName: "magnifyingglass")
        
        return image
    }()
    
    
     // MARK: THIS IS DUMMY DATA
    var contentData: [SectionModel] = []
    
    
     // MARK: to store filtered data
    var filteredData: [String] = []
    
     // MARK: to store random index data
    var randomIndex: [Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "\(HighlightTableViewCell.self)", bundle: nil), forCellReuseIdentifier: "highlightCell")
        tableView.register(UINib(nibName: "\(CardTableViewCell.self)", bundle: nil), forCellReuseIdentifier: "cardCell")
        
        navigationItem.title = "Resep"
        navigationItem.largeTitleDisplayMode = .always
//        buat navnya ga ke scroll
        
        filterBtn.setTitle("", for: .normal)
        filterBtn.tintColor = UIColor(named: "PrimaryColor")

        search()
        fetchData()
        self.hideKeyboardWhenTappedAround()
        
       
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        guard let safeText = textField.text else {
            return
        }
        //API.shared.fetchSearchDataAPI(urlKey: safeText)
    }
    
    @IBAction func filterBtn(_ sender: UIButton) {
//        print(Constant.shared.data.count)
    }
    
    func search() {
        searchTextField.delegate = self
        searchTextField.placeholder = "Pencarian"
        searchTextField.leftViewMode = .always
//        searchTextField.leftView = UIImageView(image: UIImage(systemName: "magnifyingglass")).frame.size
        searchTextField.leftView = imageIcon
        searchTextField.leftView?.tintColor = .systemGray
        searchTextField.layer.cornerRadius = 10
        searchTextField.backgroundColor = UIColor(named: "SecondaryTintColor")
//        searchTextField.borderStyle = .none
        searchTextField.layer.borderWidth = 1
        searchTextField.layer.borderColor = UIColor.white.cgColor
        searchTextField.clipsToBounds = true
        searchTextField.addTarget(self, action: #selector(ResepViewController.textFieldDidChange(_:)), for: .editingChanged)
    }
    
    func fetchData() {
//        API.shared.fetchDataAPI(urlKey: Constant.shared.getKey(key: Constant.Key.desert)){
            API.shared.fetchDataAPI(urlKey: Constant.shared.getKey(key: Constant.Key.hari_raya)){
                API.shared.fetchDataAPI(urlKey: Constant.shared.getKey(key: Constant.Key.tradisional)){
                    API.shared.fetchDataAPI(urlKey: Constant.shared.getKey(key: Constant.Key.makan_malam)){
                        API.shared.fetchNewestResepDataAPI {
                            var highlight: [Content] = []
                            for _ in 0..<5 {
                                let randomInt = Int.random(in: 0..<Constant.shared.data.count)
                                let data = Content(image: UIImage(data: Constant.shared.getImage(urlKey: Constant.shared.data[randomInt].thumb))!, label: Constant.shared.data[randomInt].title)
                                highlight.append(data)
                            }
                            self.contentData.append(SectionModel(title: "", content: highlight))
                            
                            var new: [Content] = []
                            for content in Constant.shared.newest {
                                let data = Content(image: UIImage(data: Constant.shared.getImage(urlKey: content.thumb))!, label: content.title)
                                new.append(data)
                            }
                            self.contentData.append(SectionModel(title: "Resep terbaru", content: new))
                            
                            self.contentData.append(SectionModel(title: "Terakhir Dilihat", content:
                                                                    [Content(image: UIImage(systemName: "person.fill")!, label: "Cah Bayam"),
                                                                    Content(image: UIImage(systemName: "chevron.left")!, label: "Sayur Asam")]
                                                                    )
                                         )
                            
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                            }
                        }
                      
                        
                    }
                }
            }
        }
//    }

//    func randomize() {
//        for _ in 0..<5 {
//            let randomInt = Int.random(in: 0..<contentData.count)
//            randomIndex.append(randomInt)
//        }
//    }
    
}

extension ResepViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
//        print(Constant.shared.data.count)
        return contentData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "highlightCell") as! HighlightTableViewCell
            cell.tempModelHTab = contentData[indexPath.section].content
            cell.highlightPageController.numberOfPages = 5
            
            return cell
        }
   
        let cell = tableView.dequeueReusableCell(withIdentifier: "cardCell") as! CardTableViewCell
        cell.tempModelCTab = contentData[indexPath.section].content

        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return contentData[section].title
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let sectionView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 25))
        let sectionLabel = UILabel(frame: CGRect(x: 20.0, y: 0, width: sectionView.frame.width, height: 25))
        
        sectionLabel.textColor = UIColor(named: "TextColor")
        sectionLabel.text = self.tableView(tableView, titleForHeaderInSection: section)
        
        sectionView.addSubview(sectionLabel)
        
        return sectionView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0.0
        }
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 234
        }
        
        return 190
    }
}

extension ResepViewController: UITextFieldDelegate, UISearchBarDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        return true
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
        }

        searchTextField.text = ""
    }
}

extension ResepViewController {
    func hideKeyboardWhenTappedAround() {
         // MARK: Looks for single or multiple taps
        let tap = UITapGestureRecognizer(target: self, action: #selector(ResepViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
     // MARK: Calls this function when the tap is recognized
    @objc func dismissKeyboard() {
         // MARK: Causes the view (or one of its embedded text fields) to resign the first responder status
        view.endEditing(true)
    }
}
