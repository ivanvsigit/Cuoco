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
    
    let searchBar = UISearchBar()
//    let searchBar = UISearchController(searchResultsController: SearchResultViewController())
    
    let vc = SearchResultViewController()
    
     // MARK: THIS IS DUMMY DATA
    var contentData: [SectionModel] = []
    
     // MARK: to store filtered data
    var filteredData: [Content] = []
    
     // MARK: to store random index data
    var randomIndex: [Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        setUp()
       
    }
    
    func setUp() {
        tableView.register(UINib(nibName: "\(HighlightTableViewCell.self)", bundle: nil), forCellReuseIdentifier: "highlightCell")
        tableView.register(UINib(nibName: "\(CardTableViewCell.self)", bundle: nil), forCellReuseIdentifier: "cardCell")
        
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor(named: "TextColor")!, .font: UIFont(name: "Poppins-SemiBold", size: 17)!]
        
        navigationItem.titleView = searchBar
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "slider.horizontal.3"), style: .plain, target: self, action: #selector(showFilter))
        navigationItem.rightBarButtonItem?.tintColor = UIColor(named: "PrimaryColor")
        
        searchBar.delegate = self
        searchBar.searchTextField.backgroundColor = UIColor(named: "SecondaryTintColor")
        searchBar.placeholder = "Pencarian"
        searchBar.tintColor = UIColor(named: "PrimaryColor")

    }
    
    @objc func showFilter() {
        let vc = FilterViewController()
        vc.modalPresentationStyle = .custom
        vc.transitioningDelegate = self
        self.present(vc, animated: true, completion: nil)
    }
    
    func fetchData() {
//        API.shared.fetchDataAPI(urlKey: Constant.shared.getKey(key: Constant.Key.desert)){
            API.shared.fetchDataAPI(urlKey: Constant.shared.getKey(key: Constant.Key.hari_raya)){
                API.shared.fetchDataAPI(urlKey: Constant.shared.getKey(key: Constant.Key.tradisional)){
                    API.shared.fetchDataAPI(urlKey: Constant.shared.getKey(key: Constant.Key.makan_malam)){
                        API.shared.fetchNewestResepDataAPI {
                            var highlight: [Content] = []
                            var tempIndex = 0
                            for _ in 0..<5 {
                                var randomInt = Int.random(in: 0..<Constant.shared.data.count)
                                 // MARK: Randomize var randomInt when tempIndex value is equal to randomInt
                                if randomInt == tempIndex {
                                    randomInt = Int.random(in: 0..<Constant.shared.data.count)
                                }
                                tempIndex = randomInt
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
            return 244
        }
        
        return 190
    }
}

extension ResepViewController: UISearchBarDelegate {
     // MARK: Func notify if the text field is edited
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        let vc = SearchResultViewController()
        
         // MARK: Wrap vc searchResult with navbar
        let navVC = UINavigationController(rootViewController: vc)
        navVC.modalPresentationStyle = .fullScreen
        self.present(navVC, animated: false, completion: nil)
    }
}

extension ResepViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        PresentationController(presentedViewController: presented, presenting: presenting)
    }
}
