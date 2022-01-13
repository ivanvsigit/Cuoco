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
    
    let vc = SearchResultViewController()
    
     // MARK: THIS IS DUMMY DATA
    var contentData: [SectionModel] = []
    
    
     // MARK: to store filtered data
    var filteredData: [String] = []
    
     // MARK: to store random index data
    var randomIndex: [Int] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        fetchData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "\(HighlightTableViewCell.self)", bundle: nil), forCellReuseIdentifier: "highlightCell")
        tableView.register(UINib(nibName: "\(CardTableViewCell.self)", bundle: nil), forCellReuseIdentifier: "cardCell")
        
        navigationItem.title = "Resep"
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor(named: "TextColor")!, .font: UIFont(name: "Poppins-SemiBold", size: 17)!]
        navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor(named: "TextColor")!, .font: UIFont(name: "Poppins-Bold", size: 32)!]
        
//        buat navnya ga ke scroll
        
        filterBtn.setTitle("", for: .normal)
        filterBtn.tintColor = UIColor(named: "PrimaryColor")

        search()
       
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
        searchTextField.leftViewMode = .always
//        searchTextField.leftView = UIImageView(image: UIImage(systemName: "magnifyingglass")).frame.size
        searchTextField.leftView = imageIcon
        searchTextField.leftView?.tintColor = UIColor(named: "TextColor")
        searchTextField.layer.cornerRadius = 10
        searchTextField.backgroundColor = UIColor(named: "SecondaryTintColor")
//        searchTextField.borderStyle = .none
        searchTextField.layer.borderWidth = 1
        searchTextField.layer.borderColor = UIColor.white.cgColor
        searchTextField.clipsToBounds = true
        searchTextField.addTarget(self, action: #selector(ResepViewController.textFieldDidChange(_:)), for: .editingChanged)
        searchTextField.attributedPlaceholder = NSAttributedString(string: "Pencarian", attributes: [NSAttributedString.Key.foregroundColor: UIColor(named: "TextColor")!])
        searchTextField.font = UIFont(name: "Poppins-Regular", size: 17)
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
        sectionLabel.font = UIFont(name: "Poppins-SemiBold", size: 22)
        
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
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        if searchTextField.text?.count!= 0 {
//            self.filteredData.removeAll()
//        }
        
//        searchTextField.endEditing(true)
//        return true
//    }
    
     // MARK: while editing will display another view
    func textFieldDidBeginEditing(_ textField: UITextField) {
        addChild(vc)
        vc.view.frame.size = view.sizeThatFits(CGSize(width: 350, height: 500))
        view.addSubview(vc.view)
        vc.didMove(toParent: self)
//        searchTextField.endEditing(true)
//        vc.view.translatesAutoresizingMaskIntoConstraints = false
//        vc.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
//        vc.view.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
//        vc.view.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
     
//    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
//        if searchTextField.text != "" {
//            return true
//        }
//        else {
//            searchTextField.placeholder = "Masukan Kata Kunci"
//            return false
//        }
//    }
    
     // MARK: Func after done editing
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if let data = searchTextField.text {
            //TODO: Func fetch data
            data.lowercased().range(of: searchTextField.text!, options: .caseInsensitive, range: nil, locale: nil)
        }
        
        searchTextField.text = ""
        
         // MARK: after editing will remove the other view and back to previous view
        willMove(toParent: nil)
        vc.view.removeFromSuperview()
    
        
    }
}
