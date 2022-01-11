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
    var dummyContent: [SectionModel] = []
    
    // MARK: Hold the API Data
    var data = [DataContent]()
    
     // MARK: to store filtered data
    var filteredData: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        fetchDataAPI(urlKey: Constant.shared.getKey(key: Constant.Key.seafood))
        fetchData()
//
//        }
        
        
        tableView.register(UINib(nibName: "\(HighlightTableViewCell.self)", bundle: nil), forCellReuseIdentifier: "highlightCell")
        tableView.register(UINib(nibName: "\(CardTableViewCell.self)", bundle: nil), forCellReuseIdentifier: "cardCell")
        
        filterBtn.setTitle("", for: .normal)
        
        navigationItem.title = "Resep"
        navigationItem.largeTitleDisplayMode = .always

//        dummyContent.append(SectionModel(title: "", content: [Content(image: UIImage(named: "transparent-background-pattern")!, label: "Bayam Kuah"),
//                                                         Content(image: UIImage(systemName: "chevron.left")!, label: "Kangkung Belacan")]
//                                   )
//        )
        
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
        
        filterBtn.tintColor = UIColor(named: "PrimaryColor")
      
        searchTextField.addTarget(self, action: #selector(ResepViewController.textFieldDidChange(_:)), for: .editingChanged)
      
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        guard let safeText = textField.text else {
            return
        }
        API.shared.fetchSearchDataAPI(urlKey: safeText)
    }
    
    @IBAction func filterBtn(_ sender: UIButton) {
        print(Constant.shared.data.count)
    }
    
    func fetchData() {
//        API.shared.fetchDataAPI(urlKey: Constant.shared.getKey(key: Constant.Key.desert)){
            API.shared.fetchDataAPI(urlKey: Constant.shared.getKey(key: Constant.Key.hari_raya)){
                API.shared.fetchDataAPI(urlKey: Constant.shared.getKey(key: Constant.Key.tradisional)){
                    API.shared.fetchDataAPI(urlKey: Constant.shared.getKey(key: Constant.Key.makan_malam)){
                        API.shared.fetchNewestResepDataAPI {
                            var contents: [Content] = []
                            for content in Constant.shared.data {
                                let data = Content(image: UIImage(named: content.thumb) ?? UIImage(), label: content.title)
                                contents.append(data)
                            }
                            self.dummyContent.append(SectionModel(title: "", content: contents))
                            
                            var new: [Content] = []
                            for content in Constant.shared.newest {
                                let data = Content(image: UIImage(named: content.thumb) ?? UIImage(), label: content.title)
                                new.append(data)
                            }
                            self.dummyContent.append(SectionModel(title: "Resep terbaru", content: new))
                            
                            self.dummyContent.append(SectionModel(title: "Terakhir Dilihat", content:
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
}

extension ResepViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
//        print(Constant.shared.data.count)
        
        return dummyContent.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "highlightCell") as! HighlightTableViewCell
            cell.tempModelHTab = dummyContent[indexPath.section].content
            cell.highlightPageController.numberOfPages = 5
            
            return cell
        }
   
        let cell = tableView.dequeueReusableCell(withIdentifier: "cardCell") as! CardTableViewCell
        cell.tempModelCTab = dummyContent[indexPath.section].content

        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return dummyContent[section].title
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
    
}
