//
//  ResepDetailViewController.swift
//  Skripsi AMIN
//
//  Created by Ivan Valentino Sigit on 18/01/22.
//

import UIKit

struct DropData{
    var opened: Bool
    var title: String
    var desc: [String]
}

class ResepDetailViewController: UIViewController {

    @IBOutlet weak var resepImage: UIImageView!
    @IBOutlet weak var titleResep: UILabel!
    @IBOutlet weak var durasi: UILabel!
    @IBOutlet weak var porsi: UILabel!
    @IBOutlet weak var level: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: Hold API Detail Resep Data
    var detailData: DetailContent?
    var tableViewData: [DropData] = []
    
    var resepKey: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Kembali", style: .plain, target: self, action: #selector(addTapped))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Simpan", style: .plain, target: self, action: #selector(addTapped))
        self.tabBarController?.tabBar.isHidden = true
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        setupTableView()
        fetchData()
    }
    
    @objc func addTapped(sender: AnyObject){
        self.tabBarController?.tabBar.isHidden = false
        navigationController?.popToRootViewController(animated: true)
    }
    
    
    
    func loadDetail(){
        guard let detail = detailData else{
            return
        }
        
        guard let image = detail.thumb else{
            return
        }
        
        resepImage.image = UIImage(data: Constant.shared.getImage(urlKey: image))
        titleResep.text = detail.title
        durasi.text = detail.times
        porsi.text = detail.servings
        level.text = detail.dificulty
        tableViewData = [
            DropData(opened: false, title: "Bahan", desc: detail.ingredient),
            DropData(opened: false, title: "Langkah", desc: detail.step)
        ]
        
        
    }

    fileprivate func setupTableView(){
        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 423).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20).isActive = true
        
        tableView.register(UINib(nibName: "\(DetailTableViewCell.self)", bundle: nil), forCellReuseIdentifier: "dropDown")
        tableView.delegate = self
        tableView.dataSource = self
    }

    
    var selectedIndex: IndexPath = IndexPath(row: 0, section: 0)
    
    func fetchData(){
        API.shared.fetchDetailAPI(urlKey: resepKey) { data in
            self.detailData = data
//            guard let detail = self.detailData else{
//                return
//            }
//            print(detail)
//            print(self.resepKey)
            DispatchQueue.main.async {
                self.loadDetail()
                self.tableView.reloadData()
            }
        }
    }
}

extension ResepDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableViewData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableViewData[section].opened == true {
            return tableViewData[section].desc.count + 1
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dataIndex = indexPath.row - 1
        if indexPath.row == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "dropDown") as! DetailTableViewCell
            cell.textLabel?.text = tableViewData[indexPath.section].title
            cell.textLabel?.font = UIFont(name: "Poppins-Medium", size: 20)
            cell.dropBtn.isHidden = false
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "dropDown") as! DetailTableViewCell
            cell.textLabel?.text = tableViewData[indexPath.section].desc[dataIndex]
            cell.textLabel?.font = UIFont(name: "Poppins-Regular", size: 14)
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.textAlignment = .justified
            cell.dropBtn.isHidden = true
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "dropDown") as! DetailTableViewCell
            if tableViewData[indexPath.section].opened == true {
                tableViewData[indexPath.section].opened = false
                let sections = IndexSet.init(integer: indexPath.section)
                tableView.reloadSections(sections, with: .none)
                cell.dropBtn.image = UIImage(named: "chevron.up")
            } else {
                tableViewData[indexPath.section].opened = true
                let sections = IndexSet.init(integer: indexPath.section)
                tableView.reloadSections(sections, with: .none)
                cell.dropBtn.image = UIImage(named: "chevron.up")
            }
        }
        
//        selectedIndex = indexPath
//
//        tableView.beginUpdates()
//        tableView.reloadRows(at: [selectedIndex], with: .none)
//        tableView.endUpdates()
    }
}

