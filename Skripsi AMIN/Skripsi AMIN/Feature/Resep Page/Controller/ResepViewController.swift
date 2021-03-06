//
//  ResepViewController.swift
//  Skripsi AMIN
//
//  Created by Vivian Angela on 30/12/21.
//

import UIKit
import AVFoundation
import CoreData

class ResepViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let imgLoad: UIImageView = {
       let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.animationImages = (0...5).map ({
            value in return UIImage(named: "animated-1-\(value)") ?? UIImage()
        })
        image.animationRepeatCount = -1
        image.animationDuration = 1
        image.startAnimating()
        
        return image
    }()
  
    //MARK: Sava Detail to Core Data
    let context: NSManagedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var models = [SimpanResepDetail]()
    
    let searchBar = UISearchBar()
    
    let vc = SearchResultViewController()
    
     // MARK: THIS IS DUMMY DATA
    var contentData: [SectionModel] = []
    var temp: [SectionModel] = []
    
     // MARK: to store random index data
    var randomIndex: [Int] = []
    
    var history: [Content] = []
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Kembali", style: .plain, target: nil, action: nil)
        
        if OnboardingState.shared.isNewUser() == false {
            launchScreen()
            print(OnboardingState.shared.isNewUser())
        }
        DataManipulation.shared.getItem()
        fetchData()
        setUp()
      
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
    }
    
    func launchScreen(){
        let launch = LaunchViewController()
        launch.modalPresentationStyle = .fullScreen
        self.present(launch, animated: false)
    }
    
    func setUp() {
        tableView.register(UINib(nibName: "\(HighlightTableViewCell.self)", bundle: nil), forCellReuseIdentifier: "highlightCell")
        tableView.register(UINib(nibName: "\(CardTableViewCell.self)", bundle: nil), forCellReuseIdentifier: "cardCell")
        tableView.register(UINib(nibName: "\(CategoryTableViewCell.self)", bundle: nil), forCellReuseIdentifier: "categoryCell")
        
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor(named: "TextColor")!, .font: UIFont(name: "Poppins-SemiBold", size: 17)!]
        
        navigationItem.titleView = searchBar
        
        searchBar.delegate = self
        searchBar.searchTextField.backgroundColor = UIColor(named: "SecondaryTintColor")
        searchBar.placeholder = "Pencarian"
        searchBar.tintColor = UIColor(named: "PrimaryColor")

    }
    
    //MARK: Fetch Data from API
    func fetchData() {
        DispatchQueue.main.async {
            self.view.addSubview(self.imgLoad)
            self.imgLoad.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
            self.imgLoad.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
            self.imgLoad.heightAnchor.constraint(equalToConstant: 200).isActive = true
            self.imgLoad.widthAnchor.constraint(equalToConstant: 200).isActive = true

            self.tableView.reloadData()
        }
//        API.shared.fetchDataAPI(urlKey: Constant.shared.getKey(key: Constant.Key.desert)){
            API.shared.fetchDataAPI(urlKey: Constant.shared.getKey(key: Constant.Key.hari_raya)){
                API.shared.fetchDataAPI(urlKey: Constant.shared.getKey(key: Constant.Key.tradisional)){
                    API.shared.fetchDataAPI(urlKey: Constant.shared.getKey(key: Constant.Key.makan_malam)){
                        API.shared.fetchNewestResepDataAPI {
                            //MARK: Highlight Section
                            var highlight: [Content] = []
                            var tempIndex = 0
                            for _ in 0..<5 {
                                var randomInt = Int.random(in: 0..<Constant.shared.data.count)
                                 // MARK: Randomize var randomInt when tempIndex value is equal to randomInt
                                if randomInt == tempIndex {
                                    randomInt = Int.random(in: 0..<Constant.shared.data.count)
                                }
                                tempIndex = randomInt
                                let data = Content(image: UIImage(data: Constant.shared.getImage(urlKey: Constant.shared.data[randomInt].thumb))!, label: Constant.shared.data[randomInt].title, detailKey: Constant.shared.data[randomInt].key)
                                highlight.append(data)
                            }
                            self.contentData.append(SectionModel(title: "Rekomendasi", content: highlight))
                            
                            //MARK: Category Section
                            self.contentData.append(SectionModel(title: "Kategori", content: [Content(image: UIImage(named: "Vege")!, label: "Sayuran", detailKey: Constant.shared.getKey(key:                                                               Constant.Key.sayuran)),
                                                                                      Content(image: UIImage(named: "Beef")!, label: "Daging", detailKey: Constant.shared.getKey(key: Constant.Key.daging)),
                                                                                      Content(image: UIImage(named: "Seafood")!, label: "Seafood", detailKey: Constant.shared.getKey(key: Constant.Key.seafood)),
                                                                                      Content(image: UIImage(named: "Chiken")!, label: "Ayam", detailKey: Constant.shared.getKey(key: Constant.Key.ayam)),
                                                                                      Content(image: UIImage(named: "Breakfast")!, label: "Sarapan", detailKey: Constant.shared.getKey(key: Constant.Key.sarapan)),
                                                                                      Content(image: UIImage(named: "Lunch")!, label: "Makan Siang", detailKey: Constant.shared.getKey(key: Constant.Key.makan_siang)),
                                                                                      Content(image: UIImage(named: "Dinner")!, label: "Makan Malam", detailKey: Constant.shared.getKey(key: Constant.Key.makan_malam)),
                                                                                      Content(image: UIImage(named: "Desert")!, label: "Makanan Penutup", detailKey: Constant.shared.getKey(key: Constant.Key.desert)),
                                                                                      Content(image: UIImage(named: "Feast")!, label: "Hari Raya", detailKey: Constant.shared.getKey(key: Constant.Key.hari_raya)),
                                                                                      Content(image: UIImage(named: "Traditional")!, label: "Tradisional", detailKey: Constant.shared.getKey(key: Constant.Key.tradisional))
                                                                                     ]
                                                                )
                                                    )
                            
                            //MARK: Resep Terbaru
                            var new: [Content] = []
                            for content in Constant.shared.newest {
                                let data = Content(image: UIImage(data: Constant.shared.getImage(urlKey: content.thumb))!, label: content.title, detailKey: content.key)
                                new.append(data)
                            }
                            print(new)
                            self.contentData.append(SectionModel(title: "Resep terbaru", content: new))

                            //MARK: Terakhir Dilihat
                            self.history = []
                            for model in DataManipulation.shared.model {
                                let data = Content(image: (UIImage(data: Constant.shared.getImage(urlKey: model.image!)))!, label: model.label!, detailKey: model.key)
                                self.history.append(data)
                            }
                            self.contentData.append(SectionModel(title: "Terakhir Dilihat", content: self.history))
                            print("print history")
                            print(self.history)
                            
                            for data in self.contentData{
                                self.temp.append(SectionModel(title: data.title, content: data.content))
                            }
                            print("ini temp")
                            print(self.temp)
                            
                            DispatchQueue.main.async {
                                
                                self.tableView.reloadData()
                                self.imgLoad.removeFromSuperview()
                                if OnboardingState.shared.isNewUser() == true {
                                    OnboardingState.shared.setIsNotNewUser()
                                }
                                print(OnboardingState.shared.isNewUser())
                            }
                        }
                      
                        
                    }
                }
            }
        }
    
    func reloadHistory() {
//        self.temp.removeLast()
        DataManipulation.shared.model.removeAll()
        DataManipulation.shared.getItem()
        for model in DataManipulation.shared.model {
            let data = Content(image: (UIImage(data: Constant.shared.getImage(urlKey: model.image!)))!, label: model.label!, detailKey: model.key)
            self.history.append(data)
        }
        self.temp.append(SectionModel(title: "Terakhir Dilihat", content: self.history))
        for data in self.temp{
            self.contentData.append(SectionModel(title: data.title, content: data.content))
        }
        
        DispatchQueue.main.async {
//            self.tableView.reloadData()
        }
    }

    
}

extension ResepViewController: UITableViewDelegate, UITableViewDataSource, HighlightTableViewDelegate, CardTableViewDelegate, CategoryTableViewDelegate, HistoryColDelegate{
    func triggerReloadCollection() {
        reloadHistory()

        print("delegate oke")
    }
    
    //MARK: Push to Resep Detail
    func passDataDetail(key: String) {
        let vc = ResepDetailViewController()
        vc.resepKey = key
        print(key)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func passDataCategory(key: String, index: Int) {
        let vc = CategoryViewController()
        vc.categoryKey = key
        vc.categoryTitle = contentData[1].content[index].label
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func passData(key: String) {
        let vc = ResepDetailViewController()
        vc.resepKey = key
        navigationController?.pushViewController(vc, animated: true)
//        navigationController?.pushViewController(vc, animated: true)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if OnboardingState.shared.isNewUser() == false {
            if contentData.count > 0 {
                self.dismiss(animated: false)
                print(OnboardingState.shared.isNewUser())
            }
        }
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
            cell.delegate = self
            
            return cell
        }
        else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell") as! CategoryTableViewCell
            cell.categoryData = contentData[indexPath.section].content
            cell.delegate = self
            
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cardCell") as! CardTableViewCell
            if history.count == 0 { //MARK: Load Empty State
                cell.addSubview(self.emptyState)
                self.emptyState.centerYAnchor.constraint(equalTo: cell.centerYAnchor).isActive = true
                self.emptyState.centerXAnchor.constraint(equalTo: cell.centerXAnchor).isActive = true
                self.emptyState.heightAnchor.constraint(equalToConstant: 200).isActive = true
                self.emptyState.widthAnchor.constraint(equalToConstant: 200).isActive = true
            }
            cell.tempModelCTab = contentData[indexPath.section].content
            cell.delegate = self
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return contentData[section].title
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 || section == 1 {
            return UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        }
        let sectionView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 25))
        let sectionLabel = UILabel(frame: CGRect(x: 20.0, y: 0, width: sectionView.frame.width, height: 25))
        
        sectionLabel.textColor = UIColor(named: "TextColor")
        sectionLabel.text = self.tableView(tableView, titleForHeaderInSection: section)
        sectionLabel.font = UIFont(name: "Poppins-SemiBold", size: 22)
        
        sectionView.addSubview(sectionLabel)
        
        return sectionView
    }
    
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        if section == 0 {
//            return 0.0
//        }
//        else {
//            return UITableView.automaticDimension
//        }
//        return 0.0
//    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 244
        }
        if indexPath.section == 1 {
            return 90
        }
       
            return 206
       
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
//        searchBar.endEditing(true)
    }
}

extension ResepViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
            return PresentationController(presentedViewController: presented, presenting: presenting)
        }
}
