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
    
//    var content: [DataContent] = []
    
     // MARK: THIS IS DUMMY DATA
    var dummyContent: [SectionModel] = []    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        fetchDataAPI(urlKey: Constant.shared.getKey(key: Constant.Key.seafood))
        
        tableView.register(UINib(nibName: "\(HighlightTableViewCell.self)", bundle: nil), forCellReuseIdentifier: "highlightCell")
        tableView.register(UINib(nibName: "\(CardTableViewCell.self)", bundle: nil), forCellReuseIdentifier: "cardCell")
        
        filterBtn.setTitle("", for: .normal)
        
        navigationItem.title = "Resep"
        navigationItem.largeTitleDisplayMode = .always

        dummyContent.append(SectionModel(title: "", content: [Content(image: UIImage(named: "transparent-background-pattern")!, label: "Bayam Kuah"),
                                                         Content(image: UIImage(systemName: "chevron.left")!, label: "Kangkung Belacan")]
                                   )
        )
        
        dummyContent.append(SectionModel(title: "Resep Terbaru", content: [Content(image: UIImage(systemName: "person.fill")!, label: "Soto Ayam"),
                                                         Content(image: UIImage(systemName: "chevron.left")!, label: "Pak Coy Krispi")]
                                   )
        )
        
        dummyContent.append(SectionModel(title: "Terakhir Dilihat", content: [Content(image: UIImage(systemName: "person.fill")!, label: "Cah Bayam"),
                                                         Content(image: UIImage(systemName: "chevron.left")!, label: "Sayur Asam")]
                                   )
        )
        
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
        
      
    }
    
    
    @IBAction func filterBtn(_ sender: UIButton) {
        print(Constant.shared.data.count)
    }
  
}

extension ResepViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        print(Constant.shared.data.count)
        
        return dummyContent.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "highlightCell") as! HighlightTableViewCell
            cell.tempModelHTab = dummyContent[indexPath.section].content
            cell.highlightPageController.numberOfPages = dummyContent[indexPath.section].content.count
            
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

